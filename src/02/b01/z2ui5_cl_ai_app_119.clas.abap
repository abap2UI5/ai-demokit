CLASS z2ui5_cl_ai_app_119 DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_ai_app_119 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.
  ENDMETHOD.

  METHOD view_display.
    DATA(view) = z2ui5_cl_ai_xml=>factory( ).
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `height`    v = `100%`
        )->open( n = `FixFlex` ns = `l`
            )->a( n = `class` v = `fixFlexVertical`
            )->open( n = `fixContent` ns = `l`
                )->leaf( `Image`
                    )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
                    )->a( n = `densityAware` v = `true`

            )->shut(
            )->open( n = `flexContent` ns = `l`
                )->leaf( `Text`
                    )->a( n = `class` v = `column1`
                    )->a( n = `text`  v = `This container is flexible and it will adapt its size to fill the remaining size in the FixFlex control` ).
    client->view_display( view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
