*&---------------------------------------------------------------------*
*& Report  ZABAPTRRP08_JM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabaptrrp08_jm.


INCLUDE zabaptrrp08_jm_c01. "Include para primeira classe do programa

DATA: go_carga TYPE REF TO lcl_carga. "Classe local

PARAMETERS: p_file TYPE rlgrap-filename. "Parâmetro para leitura de dados

*No momento que for requisitado um valor, preencherá a variável p_file
at SELECTION-SCREEN on value-request for p_file.
  lcl_carga=>get_file( changing cv_file = p_file ). "Chamada de método estático devido não existir instâncias de objetos

START-OF-SELECTION.
  CREATE OBJECT go_carga.

  go_carga->leitura_arquivo( ).

  go_carga->processamento( ).

  go_carga->log( ).