CLASS z2ui5_cl_ai_app_279 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA has_error TYPE abap_bool.
    DATA image_src TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_279 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `defaultSpan` v = `XL3 L3 M6 S12`

                    )->open( n = `content` ns = `l`
                        )->open( `VBox`
                            )->a( n = `alignItems` v = `Center`

                            )->leaf( `Button`
                                )->a( n = `text`  v = `Set wrong src`
                                )->a( n = `press` v = client->_event( `SET_SRC` )

                            )->open( `Image`
                                )->a( n = `load`    v = client->_event( `LOAD` )
                                )->a( n = `error`   v = client->_event( `ERROR` )
                                )->a( n = `visible` v = |\{= !${ client->_bind( has_error ) } \}|
                                )->a( n = `src`     v = client->_bind( image_src )
                                " the controller's phone branch stays a branch: the device model
                                " decides the size in the frontend, the original resolved it once at onInit
                                )->a( n = `height`  v = |\{= $\{device>/system/phone\} ? '5em' : '10em' \}|
                                )->a( n = `width`   v = |\{= $\{device>/system/phone\} ? '5em' : '10em' \}|

                                )->open( `layoutData`
                                    )->leaf( `FlexItemData`
                                        )->a( n = `growFactor` v = `1`

                                )->shut(
                            )->shut(

                            )->leaf( `IllustratedMessage`
                                )->a( n = `description`      v = `Image was not found`
                                )->a( n = `title`            v = `Not Found`
                                )->a( n = `illustrationType` v = `sapIllus-ErrorScreen`
                                )->a( n = `visible`          v = |\{= ${ client->_bind( has_error ) } \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LOAD`.

        has_error = abap_false.
        client->view_model_update( ).

      WHEN `ERROR`.

        has_error = abap_true.
        client->view_model_update( ).

      WHEN `SET_SRC`.

        " original: the img> model's /products/pic1 is overwritten with a dead url
        image_src = `/some/random/url`.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " img>/products/pic1 of sap/ui/demo/mock/img.json, absolutized to the OpenUI5 host
    image_src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.

  ENDMETHOD.

ENDCLASS.
