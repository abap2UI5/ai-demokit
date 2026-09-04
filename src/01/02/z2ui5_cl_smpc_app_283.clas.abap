" @keywords theming sap.ui.core themecustomclasses messagestrip table column text columnlistitem html
" @summary Sample display of 'sapTheme'-prefixed CSS classes for theme-independent styling of custom HTML/Controls. The set displayed is to be used to style static HTML elements.
CLASS z2ui5_cl_smpc_app_283 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_style,
        styleclass    TYPE string,
        stylingstring TYPE string,
        borderstyle   TYPE string,
      END OF ty_s_style.
    TYPES ty_t_style TYPE STANDARD TABLE OF ty_s_style WITH DEFAULT KEY.

    DATA t_styles TYPE ty_t_style.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_283 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->tag( `MessageStrip`
            )->a( n = `text`     v = `These css classes are only a subset of the less theming parameters. Be aware that they can not be applied to all use cases. `
                                    && `If possible make use of the less theming parameters. `
            )->a( n = `type`     v = `Warning`
            )->a( n = `showIcon` v = `true`
            )->a( n = `class`    v = `sapUiMediumMarginBottom`

        )->ele( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `items` v = client->_bind( t_styles )

            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width`  v = `22em`
                    )->a( n = `hAlign` v = `Left`

                    )->tag( `Text`
                        )->a( n = `text` v = `Style Class Name`

                )->end(

                )->ele( `Column`
                    )->a( n = `demandPopin` v = `true`
                    )->a( n = `hAlign`      v = `Center`

                    )->tag( `Text`
                        )->a( n = `text` v = `Sample`

                )->end(

                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `width`          v = `22em`
                    )->a( n = `hAlign`         v = `Right`

                    )->tag( `Text`
                        )->a( n = `text` v = `Css String`

                )->end(
            )->end(

            )->ele( `items`

                )->ele( `ColumnListItem`

                    )->ele( `cells`
                        )->tag( `Text`
                            )->a( n = `text` v = `{STYLECLASS}`

                        " the sampled class rides in a REAL binding inside the raw markup, so
                        " these braces stay unescaped; the border style is computed in ABAP
                        " (the original sets it on the DOM node in onAfterRendering)
                        )->tag( n = `HTML` ns = `core`
                            )->a( n = `content` v = `<div class="{STYLECLASS} sampling" style="{BORDERSTYLE}"> Sample </div>`

                        )->tag( `Text`
                            )->a( n = `text` v = `{STYLINGSTRING}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original scrapes document.styleSheets for every selector containing
    " sapTheme - a browser-only operation. The same set is seeded here from the
    " OpenUI5 base theme source (themes/base/parameterClasses.less).
    DATA temp1 TYPE z2ui5_cl_smpc_app_283=>ty_t_style.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-styleclass = `sapThemeFont`.
    temp2-stylingstring = `font-family: var(--sapFontFamily) !important; font-size: var(--sapFontSize) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeFontFamily`.
    temp2-stylingstring = `font-family: var(--sapFontFamily) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeFontSize`.
    temp2-stylingstring = `font-size: var(--sapFontSize) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeText`.
    temp2-stylingstring = `color: var(--sapTextColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeText-asColor`.
    temp2-stylingstring = `color: var(--sapTextColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeText-asBackgroundColor`.
    temp2-stylingstring = `background-color: var(--sapTextColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeText-asBorderColor`.
    temp2-stylingstring = `border-color: var(--sapTextColor) !important;`.
    temp2-borderstyle = `border-style: solid;`.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeText-asOutlineColor`.
    temp2-stylingstring = `outline-color: var(--sapTextColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeTextInverted`.
    temp2-stylingstring = `color: var(--sapContent_ContrastTextColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeTextInverted-asColor`.
    temp2-stylingstring = `color: var(--sapContent_ContrastTextColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeBaseBG`.
    temp2-stylingstring = `background-color: var(--sapBackgroundColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeBaseBG-asBackgroundColor`.
    temp2-stylingstring = `background-color: var(--sapBackgroundColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeBaseBG-asBorderColor`.
    temp2-stylingstring = `border-color: var(--sapBackgroundColor) !important;`.
    temp2-borderstyle = `border-style: solid;`.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeBaseBG-asColor`.
    temp2-stylingstring = `color: var(--sapBackgroundColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeBrand`.
    temp2-stylingstring = `color: var(--sapBrandColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeBrand-asColor`.
    temp2-stylingstring = `color: var(--sapBrandColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeBrand-asBorderColor`.
    temp2-stylingstring = `border-color: var(--sapBrandColor) !important;`.
    temp2-borderstyle = `border-style: solid;`.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeBrand-asBackgroundColor`.
    temp2-stylingstring = `background-color: var(--sapBrandColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeBrand-asOutlineColor`.
    temp2-stylingstring = `outline-color: var(--sapBrandColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeHighlight`.
    temp2-stylingstring = `color: var(--sapHighlightColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeHighlight-asColor`.
    temp2-stylingstring = `color: var(--sapHighlightColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeHighlight-asBorderColor`.
    temp2-stylingstring = `border-color: var(--sapHighlightColor) !important;`.
    temp2-borderstyle = `border-style: solid;`.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeHighlight-asBackgroundColor`.
    temp2-stylingstring = `background-color: var(--sapHighlightColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeHighlight-asOutlineColor`.
    temp2-stylingstring = `outline-color: var(--sapHighlightColor) !important;`.
    temp2-borderstyle = ``.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeForegroundBorderColor`.
    temp2-stylingstring = `border-color: var(--sapContent_ForegroundBorderColor) !important;`.
    temp2-borderstyle = `border-style: solid;`.
    INSERT temp2 INTO TABLE temp1.
    temp2-styleclass = `sapThemeForegroundBorderColor-asBorderColor`.
    temp2-stylingstring = `border-color: var(--sapContent_ForegroundBorderColor) !important;`.
    temp2-borderstyle = `border-style: solid;`.
    INSERT temp2 INTO TABLE temp1.
    t_styles = temp1.

  ENDMETHOD.

ENDCLASS.
