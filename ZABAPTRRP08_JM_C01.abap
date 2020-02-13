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
      BEGIN OF ty_s_arquivo,
        oper  TYPE zabaptrde14_jm,
        cpf   TYPE zabaptrde09_jm,
        nome  TYPE zabaptrde10_jm,
        data  TYPE zabaptrde11_jm,
        nacio TYPE zabaptrde12_jm,
        sexo  TYPE zabaptrde13_jm,
        sts   TYPE icon_d,   "Elemento de dados Standard
        msg   TYPE bapi_msg, "Elemento de dados Standard
     END OF ty_s_arquivo,

      ty_t_fn TYPE TABLE OF ty_s_arquivo.

    METHODS:
    leitura_arquivo,
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
  METHOD leitura_arquivo.

  ENDMETHOD.                    "leitura_arquivo
  METHOD processamento.

  ENDMETHOD.                    "processamento
  METHOD log.

  ENDMETHOD.                    "log
  METHOD get_file.
    DATA: lt_filetable TYPE filetable,  "Necessário criar estas variáveis para o método funcionar
          ls_file      TYPE file_table, "Estrutura work-area auxiliar
          lv_rc        TYPE i.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title           = 'Selecione o arquivo.'
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