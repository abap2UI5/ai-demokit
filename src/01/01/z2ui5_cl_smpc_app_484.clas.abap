" @keywords standardmargins standard margins sap.ui.core standardmarginsenforcewidthauto icontabbar icontabfilter simpleform title label text list
" @summary Some controls (for example the IconTabBar) do not have a 'width' property but still have a default width of 100%. We provide css class 'sapUiForceWidthAuto' to overwrite the control's width in such a case.
CLASS z2ui5_cl_smpc_app_484 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_484 IMPLEMENTATION.

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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        " the original binds expanded to its own device model's isNoPhone flag -
        " the framework's raw device> model expresses the same branch
        )->ele( `IconTabBar`
            )->a( n = `expanded` v = `{= !${device>/system/phone} }`
            )->a( n = `class`    v = `sapUiForceWidthAuto sapUiSmallMargin`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `info`
                    )->a( n = `text` v = `Info`

                    )->ele( n = `SimpleForm` ns = `f`
                        )->a( n = `layout` v = `ResponsiveGridLayout`

                        )->ele( n = `title` ns = `f`
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `A Form`

                        )->end(

                        )->tag( `Label`
                            )->a( n = `text` v = `Label`
                        )->tag( `Text`
                            )->a( n = `text` v = `Value`

                    )->end(
                )->end(

                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `attachments`
                    )->a( n = `text` v = `Attachments`

                    )->tag( `List`
                        )->a( n = `headerText`     v = `A List`
                        )->a( n = `showSeparators` v = `Inner`

                )->end(

                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `notes`
                    )->a( n = `text` v = `Notes`

                    )->tag( `FeedInput`

                )->end(
            )->end(
        )->end(

        )->tag( `Text`
            )->a( n = `text`  v = `The IconTabBar above does not have a width property and renders a default width of '100%'. ` &&
                                  `Therefore we use margin class 'sapUiForceWidthAuto' to set its width to 'auto'. To clear a ` &&
                                  `16px (1rem) space all around, we use class 'sapUiSmallMargin'.`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
