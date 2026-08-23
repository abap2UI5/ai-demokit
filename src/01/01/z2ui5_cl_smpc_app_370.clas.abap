" @keywords textarea text area sap.m textareagrowing verticallayout messagestrip simpleform label
" @summary Since 1.38 the growing property of sap.m.TextArea gives the ability of a control to automatically grow and shrink dynamically with its content.
CLASS z2ui5_cl_smpc_app_370 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_370 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
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
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->tag( `MessageStrip`
                    )->a( n = `showIcon` v = `true`
                    )->a( n = `text`     v = `This TextArea shows up to 7 lines, then a scrollbar is presented.`
                )->tag( `TextArea`
                    )->a( n = `placeholder`     v = `Enter Text`
                    )->a( n = `growing`         v = `true`
                    )->a( n = `growingMaxLines` v = `7`
                    )->a( n = `width`           v = `100%`
                )->tag( `MessageStrip`
                    )->a( n = `showIcon` v = `true`
                    )->a( n = `text`     v = `This TextArea shows up to 7 lines, then a scrollbar is presented.`
                    )->a( n = `class`    v = `sapUiMediumMarginTop`
                )->tag( `TextArea`
                    )->a( n = `value`
                             v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat. ` &&
                                 `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`
                    )->a( n = `growing`         v = `true`
                    )->a( n = `growingMaxLines` v = `7`
                    )->a( n = `width`           v = `100%`
                )->tag( `MessageStrip`
                    )->a( n = `showIcon` v = `true`
                    )->a( n = `text`     v = `This TextArea adjusts its height according to its content.`
                    )->a( n = `class`    v = `sapUiMediumMarginTop`
                )->tag( `TextArea`
                    )->a( n = `value`
                             v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat. ` &&
                                 `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`
                    )->a( n = `growing` v = `true`
                    )->a( n = `width`   v = `100%`
                )->tag( `MessageStrip`
                    )->a( n = `showIcon` v = `true`
                    )->a( n = `text`     v = `Growing TextArea in a SimpleForm`
                    )->a( n = `class`    v = `sapUiMediumMarginTop`

                )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `editable` v = `true`
                    )->a( n = `layout`   v = `ResponsiveGridLayout`

                    )->tag( `Label`
                        )->a( n = `text` v = `Comment`
                    )->tag( `TextArea`
                        )->a( n = `value`
                                 v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                     `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                     `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                     `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat. ` &&
                                     `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                     `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                     `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                     `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`
                        )->a( n = `growing` v = `true`
                        )->a( n = `width`   v = `100%` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
