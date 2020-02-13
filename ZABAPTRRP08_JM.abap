*&---------------------------------------------------------------------*
*& Report  ZABAPTRRP08_JM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZABAPTRRP08_JM.


INCLUDE zabaptrrp08_jm_c01. "Include para primeira classe do programa

DATA: go_carga TYPE REF TO lcl_carga. "Classe local

START-OF-SELECTION.
  CREATE OBJECT go_carga.

  go_carga->leitura_arquivo( ).

  go_carga->processamento( ).

  go_carga->log( ).