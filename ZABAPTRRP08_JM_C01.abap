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

ENDCLASS.                    "lcl_carga IMPLEMENTATION