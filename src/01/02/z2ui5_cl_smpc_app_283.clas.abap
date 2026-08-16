CLASS z2ui5_cl_smpc_app_283 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_style,
        styleclass    TYPE string,
        stylingstring TYPE string,
        borderstyle   TYPE string,
      END OF ty_s_style.
    TYPES ty_t_style TYPE STANDARD TABLE OF ty_s_style WITH EMPTY KEY.

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
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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
    t_styles = VALUE #(
      ( styleclass = `sapThemeFont`                               stylingstring = `font-family: var(--sapFontFamily) !important; font-size: var(--sapFontSize) !important;` borderstyle = `` )
      ( styleclass = `sapThemeFontFamily`                         stylingstring = `font-family: var(--sapFontFamily) !important;`                                          borderstyle = `` )
      ( styleclass = `sapThemeFontSize`                           stylingstring = `font-size: var(--sapFontSize) !important;`                                              borderstyle = `` )
      ( styleclass = `sapThemeText`                               stylingstring = `color: var(--sapTextColor) !important;`                                                 borderstyle = `` )
      ( styleclass = `sapThemeText-asColor`                       stylingstring = `color: var(--sapTextColor) !important;`                                                 borderstyle = `` )
      ( styleclass = `sapThemeText-asBackgroundColor`             stylingstring = `background-color: var(--sapTextColor) !important;`                                      borderstyle = `` )
      ( styleclass = `sapThemeText-asBorderColor`                 stylingstring = `border-color: var(--sapTextColor) !important;`                                          borderstyle = `border-style: solid;` )
      ( styleclass = `sapThemeText-asOutlineColor`                stylingstring = `outline-color: var(--sapTextColor) !important;`                                         borderstyle = `` )
      ( styleclass = `sapThemeTextInverted`                       stylingstring = `color: var(--sapContent_ContrastTextColor) !important;`                                 borderstyle = `` )
      ( styleclass = `sapThemeTextInverted-asColor`               stylingstring = `color: var(--sapContent_ContrastTextColor) !important;`                                 borderstyle = `` )
      ( styleclass = `sapThemeBaseBG`                             stylingstring = `background-color: var(--sapBackgroundColor) !important;`                                borderstyle = `` )
      ( styleclass = `sapThemeBaseBG-asBackgroundColor`           stylingstring = `background-color: var(--sapBackgroundColor) !important;`                                borderstyle = `` )
      ( styleclass = `sapThemeBaseBG-asBorderColor`               stylingstring = `border-color: var(--sapBackgroundColor) !important;`                                    borderstyle = `border-style: solid;` )
      ( styleclass = `sapThemeBaseBG-asColor`                     stylingstring = `color: var(--sapBackgroundColor) !important;`                                           borderstyle = `` )
      ( styleclass = `sapThemeBrand`                              stylingstring = `color: var(--sapBrandColor) !important;`                                                borderstyle = `` )
      ( styleclass = `sapThemeBrand-asColor`                      stylingstring = `color: var(--sapBrandColor) !important;`                                                borderstyle = `` )
      ( styleclass = `sapThemeBrand-asBorderColor`                stylingstring = `border-color: var(--sapBrandColor) !important;`                                         borderstyle = `border-style: solid;` )
      ( styleclass = `sapThemeBrand-asBackgroundColor`            stylingstring = `background-color: var(--sapBrandColor) !important;`                                     borderstyle = `` )
      ( styleclass = `sapThemeBrand-asOutlineColor`               stylingstring = `outline-color: var(--sapBrandColor) !important;`                                        borderstyle = `` )
      ( styleclass = `sapThemeHighlight`                          stylingstring = `color: var(--sapHighlightColor) !important;`                                            borderstyle = `` )
      ( styleclass = `sapThemeHighlight-asColor`                  stylingstring = `color: var(--sapHighlightColor) !important;`                                            borderstyle = `` )
      ( styleclass = `sapThemeHighlight-asBorderColor`            stylingstring = `border-color: var(--sapHighlightColor) !important;`                                     borderstyle = `border-style: solid;` )
      ( styleclass = `sapThemeHighlight-asBackgroundColor`        stylingstring = `background-color: var(--sapHighlightColor) !important;`                                 borderstyle = `` )
      ( styleclass = `sapThemeHighlight-asOutlineColor`           stylingstring = `outline-color: var(--sapHighlightColor) !important;`                                    borderstyle = `` )
      ( styleclass = `sapThemeForegroundBorderColor`              stylingstring = `border-color: var(--sapContent_ForegroundBorderColor) !important;`                      borderstyle = `border-style: solid;` )
      ( styleclass = `sapThemeForegroundBorderColor-asBorderColor` stylingstring = `border-color: var(--sapContent_ForegroundBorderColor) !important;`                     borderstyle = `border-style: solid;` ) ).

  ENDMETHOD.

ENDCLASS.
