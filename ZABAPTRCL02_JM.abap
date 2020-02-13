*Método SET precisou validar a data maior que 1900
METHOD modify.
  DATA: lv_save TYPE flag. "Para controlar se houve modificação

  IF iv_nome IS NOT INITIAL.
    lv_save = abap_true.
    set_nome(
      EXPORTING
        iv_nome = iv_nome ).
  ENDIF.

  IF iv_datanasc IS NOT INITIAL and iv_datanasc > 19000101.
    lv_save = abap_true.
    set_datanasc(
      EXPORTING
        iv_datanasc = iv_datanasc ).
  ENDIF.

  IF iv_nacionalidade IS NOT INITIAL.
    lv_save = abap_true.
    set_nacionalidade(
      EXPORTING
        iv_nacionalidade = iv_nacionalidade ).
  ENDIF.

  IF iv_sexo IS NOT INITIAL.
    lv_save = abap_true.
    set_sexo(
      EXPORTING
        iv_sexo = iv_sexo ).
  ENDIF.

  IF lv_save NE abap_true.
    RAISE EXCEPTION TYPE zcx_abaptr01_jm
      EXPORTING
        textid = zcx_abaptr01_jm=>modificacao_invalida.
  ENDIF.

  save( ).

ENDMETHOD.