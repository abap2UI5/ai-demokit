" @keywords blocklayout block layout sap.ui.layout blocklayoutlinktitle simpleform label slider segmentedbutton segmentedbuttonitem messagestrip verticallayout
" @summary The BlockLayout Cells can have links as titles. The link text overwrites the title text.
CLASS z2ui5_cl_smpc_app_223 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slidervalue        TYPE i.
    DATA selectedbackground TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_223 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      slidervalue        = 100.
      selectedbackground = `Default`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `editable`         v = `true`
            )->a( n = `backgroundDesign` v = `Transparent`
            )->a( n = `layout`           v = `ResponsiveGridLayout`

            )->tag( `Label`
                )->a( n = `text` v = `Parent width`
            )->tag( `Slider`
                )->a( n = `id`    v = `widthSlider`
                )->a( n = `value` v = client->_bind( slidervalue )
            )->tag( `Label`
                )->a( n = `id`   v = `backgroundLabel`
                )->a( n = `text` v = `Background`

            )->ele( `SegmentedButton`
                )->a( n = `selectedKey`     v = client->_bind( selectedbackground )
                )->a( n = `ariaDescribedBy` v = `backgroundLabel`
                )->a( n = `ariaLabelledBy`  v = `backgroundLabel`

                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `key`  v = `Default`
                        )->a( n = `text` v = `Default`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `key`  v = `Light`
                        )->a( n = `text` v = `Light`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `key`  v = `Dashboard`
                        )->a( n = `text` v = `Dashboard`

                )->end(
            )->end(
        )->end(

        )->tag( `MessageStrip`
            )->a( n = `type` v = `Warning`
            )->a( n = `text` v = `Note: Usage of Disabled, Emphasized or Subtle links as titles is not recommended. ` &&
                                 `Dark background designs, for example Accent, are not fully supported with regards to Accessibility when used with links as titles.`
            )->a( n = `class` v = `sapUiSmallMarginBeginEnd sapUiSmallMarginTop`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `id`    v = `containerLayout`
            )->a( n = `width` v = |\{= ${ client->_bind( slidervalue ) } + '%' \}|

            )->ele( n = `BlockLayout` ns = `l`
                )->a( n = `id`         v = `BlockLayout`
                )->a( n = `background` v = client->_bind( selectedbackground )

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->a( n = `accentCells` v = `Accent1`

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `id`    v = `Accent1`
                        )->a( n = `width` v = `2`
                        )->a( n = `title` v = `Left aligned heading`

                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                                 `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr.`

                        )->ele( n = `titleLink` ns = `l`
                            )->tag( `Link`
                                )->a( n = `text` v = `This is a title link`
                                )->a( n = `href` v = `https://sdk.openui5.org/`

                        )->end(
                    )->end(

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `This is just a title`

                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                                 `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr.`

                    )->end(

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `titleAlignment` v = `End`
                        )->a( n = `title`          v = `End aligned heading`

                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.`

                        )->ele( n = `titleLink` ns = `l`
                            )->tag( `Link`
                                )->a( n = `text`     v = `This is a title link - wrapping true`
                                )->a( n = `href`     v = `https://sdk.openui5.org/`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `This is just a title`

                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                                 `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr.`

                    )->end(

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `25% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                                 `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr.`

                        )->ele( n = `titleLink` ns = `l`
                            )->tag( `Link`
                                )->a( n = `text` v = `This is a title link`
                                )->a( n = `href` v = `https://sdk.openui5.org/`

                        )->end(
                    )->end(

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `25% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                                 `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr.`

                        )->ele( n = `titleLink` ns = `l`
                            )->tag( `Link`
                                )->a( n = `text`   v = `This is a title link - open in new window`
                                )->a( n = `href`   v = `https://sdk.openui5.org/`
                                )->a( n = `target` v = `_blank`

                        )->end(
                    )->end(

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `25% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                                 `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr.`

                        )->ele( n = `titleLink` ns = `l`
                            )->tag( `Link`
                                )->a( n = `text`     v = `This is a title link - wrapping true`
                                )->a( n = `href`     v = `https://sdk.openui5.org/`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
