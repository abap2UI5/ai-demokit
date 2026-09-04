" @keywords fileuploader file uploader sap.ui.unified basic html verticallayout button
" @summary Basic File Uploader Example
CLASS z2ui5_cl_smpc_app_126 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_126 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `File upload complete. Status: 200 (Upload Success)` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `fileUploader` INTO TABLE temp2.
    INSERT `upload` INTO TABLE temp2.
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

            )->tag( n = `FileUploader` ns = `u`
                )->a( n = `id`             v = `fileUploader`
                )->a( n = `name`           v = `myFileUpload`
                )->a( n = `uploadUrl`      v = `upload/`
                )->a( n = `tooltip`        v = `Upload your file to the local server`
                )->a( n = `uploadComplete` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
            )->tag( `Button`
                )->a( n = `text`  v = `Upload File`
                " handleUploadPress calls oFileUploader.upload( ), which is what makes
                " the uploadComplete toast above reachable at all - upload is an
                " ordinary public control method and is not on the frontend denylist.
                " Only the checkFileReadable( ) guard and its error toast stay dropped
                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                t_arg = temp2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
