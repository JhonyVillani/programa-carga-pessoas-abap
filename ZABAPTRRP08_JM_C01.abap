*&---------------------------------------------------------------------*
*&  Include           ZABAPTRRP08_JM_C01
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       CLASS lvl_carga DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_carga DEFINITION.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_s_dados,
        oper  TYPE zabaptrde14_jm,
        cpf   TYPE zabaptrde09_jm,
        nome  TYPE zabaptrde10_jm,
        data  TYPE zabaptrde11_jm,
        nacio TYPE zabaptrde12_jm,
        sexo  TYPE zabaptrde13_jm,
        sts   TYPE icon_d,   "Elemento de dados Standard
        msg   TYPE bapi_msg, "Elemento de dados Standard
     END OF ty_s_dados.

    DATA: mt_dados TYPE TABLE OF ty_s_dados.

    METHODS:
    leitura_dados
      IMPORTING iv_file TYPE rlgrap-filename,
    processamento,
    log.

*   Métodos estáticos (da classe)
    CLASS-METHODS:
    get_file
      CHANGING cv_file TYPE rlgrap-filename.
ENDCLASS.                    "lcl_carga DEFINITION

*----------------------------------------------------------------------*
*       CLASS lvl_carga IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_carga IMPLEMENTATION.
  METHOD leitura_dados.

*   Types para definir um tipo string de 1000 chars e ser utilizado no método da classe como tipo (de complexo para) simples
    TYPES:
    BEGIN OF ty_file_line,
      line TYPE c LENGTH 1000,
    END OF ty_file_line.

    DATA: lv_filename  TYPE string, "O método filename precisa do caminho em forma de String
          ls_file_line TYPE ty_file_line,
          lt_file_data TYPE TABLE OF ty_file_line,
          ls_dados     TYPE ty_s_dados.

    lv_filename = iv_file. "Atribuímos o caminho do dados para a variável do tipo String

*   Método para importar o dados no SAP e armazenar em data_tab
    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = lv_filename
        filetype                = 'ASC'
      CHANGING
        data_tab                = lt_file_data "Saída do dados, linhas com Strings gigantes
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.

********************************************************************** Teste

*    DATA: field1 TYPE string. "Antes de passar no Split os atributos da estrutura, testamos e validamos estes fiels no DEBUG
*    DATA: field2 TYPE string.
*    DATA: field3 TYPE string.
*    DATA: field4 TYPE string.
*    DATA: field5 TYPE string.
*    DATA: field6 TYPE string.

********************************************************************** END Teste

*   Para cada linha na tabela de Strings
    LOOP AT lt_file_data INTO ls_file_line.

      IF sy-tabix = 1. "Contador do SAP, inicia em 1
        CONTINUE.
      ENDIF.

      SPLIT ls_file_line-line AT ';' INTO ls_dados-oper "Separa por ';' e armazena na estrutura ls_dados-ORDEMdoCAMPO
                                          ls_dados-cpf
                                          ls_dados-nome
                                          ls_dados-data
                                          ls_dados-nacio
                                          ls_dados-sexo.

      APPEND ls_dados TO mt_dados.

    ENDLOOP.

  ENDMETHOD.                    "leitura_dados
  METHOD processamento.
    DATA: ls_dados   TYPE ty_s_dados,
          lo_pessoa  TYPE REF TO zabaptrcl02_jm,
          lo_except  TYPE REF TO zcx_abaptr01_jm,
          lv_message TYPE string,
          lv_tabix   TYPE sytabix.

*   Para cada linha na tabela mt_dados com as informações resgatadas, popular um objeto
    LOOP AT mt_dados INTO ls_dados.

      lv_tabix = sy-tabix.

      CLEAR: lv_message.

      TRY .
          CLEAR: lo_pessoa. "Destruir o objeto pessoa para evitar sujeira
          CREATE OBJECT lo_pessoa.

*     Para sabermos o que fazer com os dados, precisamos saber qual operação o usuário precisa
          CASE ls_dados-oper.
            WHEN 'C'. "Criar
              CALL METHOD lo_pessoa->create
                EXPORTING
                  iv_cpf           = ls_dados-cpf
                  iv_nome          = ls_dados-nome
                  iv_datanasc      = ls_dados-data
                  iv_nacionalidade = ls_dados-nacio
                  iv_sexo          = ls_dados-sexo.

            WHEN 'M'. "Modificar
              CALL METHOD lo_pessoa->buscar
                EXPORTING
                  iv_cpf = ls_dados-cpf.

              CALL METHOD lo_pessoa->modify
                EXPORTING
                  iv_nome          = ls_dados-nome
                  iv_datanasc      = ls_dados-data
                  iv_nacionalidade = ls_dados-nacio
                  iv_sexo          = ls_dados-sexo.

            WHEN 'E'. "Excluir
              CALL METHOD lo_pessoa->buscar
                EXPORTING
                  iv_cpf = ls_dados-cpf.

              CALL METHOD lo_pessoa->delete.

            WHEN OTHERS.
              lv_message = 'Operação invalida.'.
          ENDCASE.

        CATCH zcx_abaptr01_jm INTO lo_except.
          lv_message = lo_except->get_text( ).
      ENDTRY.

      IF lv_message IS INITIAL.
        ls_dados-sts = icon_led_green.
        ls_dados-msg = 'Operação realizada com sucesso!'.
      ELSE.
        ls_dados-sts = icon_led_red.
        ls_dados-msg = lv_message.
      ENDIF.

*     Para realizar as alterações realizadas na estrutura na tabela, precisamos realizar um modify
      MODIFY mt_dados FROM ls_dados INDEX lv_tabix.

    ENDLOOP.

  ENDMETHOD.                    "processamento
  METHOD log.

  ENDMETHOD.                    "log
  METHOD get_file.
    DATA: lt_filetable TYPE filetable,  "Necessário criar estas variáveis para o método funcionar
          ls_file      TYPE file_table, "Estrutura work-area auxiliar
          lv_rc        TYPE i.

*   Método para tela de diálogo para localização de endereço de dados local
    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title            = 'Selecione os dados.'
        initial_directory       = 'C:\Users\ITZ37\Downloads\'
        multiselection          = space "Space é o mesmo que FALSE
      CHANGING
        file_table              = lt_filetable
        rc                      = lv_rc
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.

    IF sy-subrc = 0.

      READ TABLE lt_filetable INTO ls_file INDEX 1. "Ler a primeira linha
      cv_file = ls_file.

    ENDIF.

  ENDMETHOD.                    "get_file

ENDCLASS.                    "lcl_carga IMPLEMENTATION