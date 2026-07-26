CLASS z2ui5_cl_ai_app_246 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_246 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `viewPadding`

        )->open( n = `VerticalLayout` ns = `l`

            )->open( n = `FileUploader` ns = `u`
                )->a( n = `id`             v = `fileUploader`
                )->a( n = `name`           v = `myFileUpload`
                )->a( n = `uploadUrl`      v = `upload/`
                )->a( n = `tooltip`        v = `Upload your file to the local server`
                )->a( n = `uploadComplete` v = client->_event_client( val   = client->cs_event-control_global
                                                                      t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `File upload complete. Status: 200 (Upload Success)` ) ) )
                )->a( n = `change`         v = client->_event_client( val   = client->cs_event-control_global
                                                                      t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Press 'Upload File' to upload file '{0}'` ) ( `${$parameters>/newValue}` ) ) )
                )->a( n = `typeMissmatch`  v = client->_event_client( val   = client->cs_event-control_global
                                                                      t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The file type *.{0} is not supported. Choose one of the following types: txt, jpg` ) ( `${$parameters>/fileType}` ) ) )
                )->a( n = `style`          v = `Emphasized`
                )->a( n = `fileType`       v = `txt,jpg`
                )->a( n = `placeholder`    v = `Choose a file for Upload...`

                )->open( n = `parameters` ns = `u`
                    )->leaf( n = `FileUploaderParameter` ns = `u`
                        )->a( n = `name`  v = `Accept-CH`
                        )->a( n = `value` v = `Viewport-Width`
                    )->leaf( n = `FileUploaderParameter` ns = `u`
                        )->a( n = `name`  v = `Accept-CH`
                        )->a( n = `value` v = `Width`
                    )->leaf( n = `FileUploaderParameter` ns = `u`
                        )->a( n = `name`  v = `Accept-CH-Lifetime`
                        )->a( n = `value` v = `86400`

                )->shut(
            )->shut(

            )->leaf( `Button`
                )->a( n = `text`  v = `Upload File`
                )->a( n = `press` v = client->_event_client( val   = client->cs_event-control_global
                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Uploading file to the local server ...` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
