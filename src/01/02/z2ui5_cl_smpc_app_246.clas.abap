" @keywords fileuploader file uploader sap.ui.unified fileuploadercomplex html verticallayout fileuploaderparameter button
" @summary File Uploader Example with Parameters
CLASS z2ui5_cl_smpc_app_246 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA file_value TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_246 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `viewPadding`

        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's own ../style.css (shared by the sap.ui.unified samples and
        " listed in this sample's manifest) - the view carries the class and the
        " rule behind it has to come with it. \{ \} escaped: the XMLView parser
        " reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.viewPadding\{padding:1rem\}` &&
                                    `.sap-phone .viewPadding\{padding:0rem\}</style>`
        )->ele( n = `VerticalLayout` ns = `l`

            )->ele( n = `FileUploader` ns = `u`
                )->a( n = `id`             v = `fileUploader`
                )->a( n = `name`           v = `myFileUpload`
                " added attr (declared): two-way value so the backend can run the
                " original's empty-value check in handleUploadPress
                )->a( n = `value`          v = client->_bind( file_value )
                )->a( n = `uploadUrl`      v = `upload/`
                )->a( n = `tooltip`        v = `Upload your file to the local server`
                )->a( n = `uploadComplete` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                         t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `File upload complete. Status: 200 (Upload Success)` ) ) )
                )->a( n = `change`         v = client->follow_up_action( val   = client->cs_event-control_global
                                                                         t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Press 'Upload File' to upload file '{0}'` ) ( `${$parameters>/newValue}` ) ) )
                )->a( n = `typeMissmatch`  v = client->follow_up_action( val   = client->cs_event-control_global
                                                                         t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The file type *.{0} is not supported. Choose one of the following types: txt, jpg` ) ( `${$parameters>/fileType}` ) ) )
                )->a( n = `style`          v = `Emphasized`
                )->a( n = `fileType`       v = `txt,jpg`
                )->a( n = `placeholder`    v = `Choose a file for Upload...`

                )->ele( n = `parameters` ns = `u`
                    )->tag( n = `FileUploaderParameter` ns = `u`
                        )->a( n = `name`  v = `Accept-CH`
                        )->a( n = `value` v = `Viewport-Width`
                    )->tag( n = `FileUploaderParameter` ns = `u`
                        )->a( n = `name`  v = `Accept-CH`
                        )->a( n = `value` v = `Width`
                    )->tag( n = `FileUploaderParameter` ns = `u`
                        )->a( n = `name`  v = `Accept-CH-Lifetime`
                        )->a( n = `value` v = `86400`

                )->end(
            )->end(

            )->tag( `Button`
                )->a( n = `text`  v = `Upload File`
                )->a( n = `press` v = client->_event( `UPLOAD` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `UPLOAD`.
      " original handleUploadPress: no chosen file -> 'Choose a file first';
      " else upload() then clear() (checkFileReadable is a client-side File
      " API probe with no declarative equivalent - its cannot-be-read branch
      " is not reproduced, see sidecar)
      IF file_value IS INITIAL.
        client->message_toast_display( `Choose a file first` ).
      ELSE.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `fileUploader` ) ( `upload` ) ) ).
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `fileUploader` ) ( `clear` ) ) ).
        file_value = ``.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
