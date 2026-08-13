CLASS z2ui5_cl_smpc_app_216 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_216 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `height`       v = `100%`

        )->open( `ObjectPageHeaderContent`
            )->open( `content`
                )->open( n = `VerticalLayout` ns = `layout`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `User ID`
                        )->a( n = `text`  v = `12345678`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Functional Area`
                        )->a( n = `text`  v = `Developement`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Cost Center`
                        )->a( n = `text`  v = `PI DFA GD Programs and Product`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Email`
                        )->a( n = `text`  v = `email@address.com`

                )->shut(

                )->leaf( n = `Text` ns = `m`
                    )->a( n = `width` v = `200px`
                    )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`
                )->leaf( n = `ObjectStatus` ns = `m`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Error`
                )->leaf( n = `ObjectStatus` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Warning`
                )->leaf( n = `ObjectNumber` ns = `m`
                    )->a( n = `number`     v = `1000`
                    )->a( n = `unit`       v = `SOOK`
                    )->a( n = `emphasized` v = `false`
                    )->a( n = `state`      v = `Success`
                )->leaf( n = `ProgressIndicator` ns = `m`
                    )->a( n = `percentValue` v = `30`
                    )->a( n = `displayValue` v = `30%`
                    )->a( n = `showValue`    v = `true`
                    )->a( n = `state`        v = `None`

                )->open( n = `VerticalLayout` ns = `layout`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Unrestricted-Use Stock`
                    )->leaf( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `219`
                        )->a( n = `unit`   v = `K`

                )->shut(

                )->open( n = `VerticalLayout` ns = `layout`
                    )->open( n = `layoutData` ns = `layout`
                        )->leaf( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleS` v = `false`

                    )->shut(

                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Small Size`
                    )->leaf( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `220`
                        )->a( n = `unit`   v = `K`

                )->shut(

                )->open( n = `VerticalLayout` ns = `layout`
                    )->open( n = `layoutData` ns = `layout`
                        )->leaf( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleM` v = `false`

                    )->shut(

                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Medium Size`
                    )->leaf( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `221`
                        )->a( n = `unit`   v = `K`

                )->shut(

                )->open( n = `VerticalLayout` ns = `layout`
                    )->open( n = `layoutData` ns = `layout`
                        )->leaf( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleL`           v = `false`
                            )->a( n = `showSeparatorAfter` v = `true`

                    )->shut(

                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Large Size`
                    )->leaf( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `219`
                        )->a( n = `unit`   v = `K`

                )->shut(

                )->leaf( n = `ObjectAttribute` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`
                )->leaf( n = `Button` ns = `m`
                    )->a( n = `icon`    v = `sap-icon://nurse`
                    )->a( n = `tooltip` v = `nurse`

                )->open( n = `Tokenizer` ns = `m`
                    )->leaf( n = `Token` ns = `m`
                        )->a( n = `text` v = `Wayne Enterprises`
                    )->leaf( n = `Token` ns = `m`
                        )->a( n = `text` v = `Big's Caramels` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
