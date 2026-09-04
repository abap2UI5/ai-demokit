" @keywords image sap.m vbox hbox text
" @summary Images are faster than words and attract people's attention. Images can also have an active state or be used in SVG format.
CLASS z2ui5_cl_smpc_app_399 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_399 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA image_width TYPE string.
    DATA pic1 TYPE string.
    DATA pic3 TYPE string.
    DATA svg_logo TYPE string.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the controller's imageWidth is Device.system.phone ? 5em : 10em - kept a
    " branch over the framework's device> model instead of resolving it at init
    
    image_width = `{= ${device>/system/phone} ? '5em' : '10em' }`.
    " fixed values of the original models: img>/products/pic1, pic3 and the
    " sample's own images/sap-logo.svg
    
    pic1     = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.
    
    pic3     = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100-large.jpg`.
    " sap.ui.require.toUrl( 'sap/m/sample/Image/images/sap-logo.svg' ) resolves
    " against the demo kit's own layout, which inserts a demokit/ segment - the
    " file is at src/sap.m/test/sap/m/demokit/sample/Image/images/. Without it
    " both SVG Images 404, and nothing catches that: the e2e smoke resolves only
    " /resources/ paths locally and ignores every other miss. Same shape as app
    " 288's sample.pdf.
    
    svg_logo = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/Image/images/sap-logo.svg`.

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `The image has been pressed` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMarginTopBottom sapUiLargeMarginBeginEnd`

            )->ele( `HBox`
                )->a( n = `justifyContent` v = `SpaceBetween`

                )->ele( `VBox`
                    )->tag( `Text`
                        )->a( n = `text`  v = `Image:`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->tag( `Image`
                        )->a( n = `src`   v = pic1
                        )->a( n = `width` v = image_width

                )->end(
                )->ele( `VBox`
                    )->tag( `Text`
                        )->a( n = `id`    v = `detailsActiveImage`
                        )->a( n = `text`  v = `Active state image:`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->tag( `Image`
                        " ariaDetails is newer than the 1.71 floor - kept for the 1:1 port (POST_171)
                        )->a( n = `ariaDetails` v = `detailsActiveImage`
                        )->a( n = `src`         v = pic3
                        )->a( n = `width`       v = image_width
                        )->a( n = `decorative`  v = `false`
                        )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp1 )

                )->end(
                )->ele( `VBox`
                    )->tag( `Text`
                        )->a( n = `text`  v = `Image using SVG format:`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->tag( `Image`
                        )->a( n = `src` v = svg_logo

                )->end(
                )->ele( `VBox`
                    )->tag( `Text`
                        )->a( n = `text`  v = `Image displaying inline SVG:`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->tag( `Image`
                        )->a( n = `src`  v = svg_logo
                        " POST-1.71: sap.m.ImageMode.InlineSvg. The enum VALUE
                        " carries no @since of its own, so no gate can see it -
                        " measured against the tags instead: at 1.71.0 ImageMode
                        " has only Image and Background
                        )->a( n = `mode` v = `InlineSvg` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
