" @keywords uploadset upload set sap.m.upload file list overflowtoolbar toolbarspacer button uploadsettoolbarplaceholder uploadsetitem objectmarker
" @summary This sample shows an Upload Set control with a list of files to be uploaded and actions you can perform on them.
CLASS z2ui5_cl_smpc_app_121 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_marker,
             type       TYPE string,
             visibility TYPE string,
           END OF ty_s_marker.
    TYPES: BEGIN OF ty_s_status,
             title  TYPE string,
             text   TYPE string,
             state  TYPE string,
             icon   TYPE string,
             active TYPE abap_bool,
           END OF ty_s_status.
    TYPES: BEGIN OF ty_s_item,
             filename     TYPE string,
             mediatype    TYPE string,
             url          TYPE string,
             thumbnailurl TYPE string,
             uploadstate  TYPE string,
             markers      TYPE STANDARD TABLE OF ty_s_marker WITH DEFAULT KEY,
             statuses     TYPE STANDARD TABLE OF ty_s_status WITH DEFAULT KEY,
           END OF ty_s_item.
    TYPES temp1_116400003e TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.
DATA t_items TYPE temp1_116400003e.
    " onSelectionChange enables the version button for exactly one selection
    DATA version_enabled TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_121 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `VISIBILITY` INTO TABLE temp1.
    INSERT `STATE` INTO TABLE temp1.
    INSERT `ICON` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:upload` v = `sap.m.upload`
        )->a( n = `height`       v = `100%`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( n = `UploadSet` ns = `upload`
                )->a( n = `id`            v = `UploadSet`
                )->a( n = `instantUpload` v = `true`
                )->a( n = `showIcons`     v = `true`
                )->a( n = `uploadEnabled` v = `true`
                )->a( n = `terminationEnabled` v = `true`
                )->a( n = `fileTypes`     v = `txt,doc,png`
                )->a( n = `maxFileNameLength` v = `30`
                )->a( n = `maxFileSize`   v = `200`
                )->a( n = `mediaTypes`    v = `text/plain,application/msword,image/png`
                )->a( n = `uploadUrl`     v = `../../../../upload`
                " omit_initial_paths so a marker that sets no visibility keeps
                " the control's own default. The original's markers are
                " {"type":"Draft"} and carry no visibility at all, so its
                " visibility="{visibility}" resolves to undefined and UI5 leaves
                " the property alone. ABAP has no undefined: the unfilled
                " TYPE string serialized as "" and sap.m.ObjectMarkerVisibility
                " rejects it, which TERMINATED the app on its first render.
                " STATE and ICON are the same story one control down: only one
                " of the original's four statuses carries a state and none
                " carries an icon, so ObjectStatus.state got "" and
                " sap.ui.core.ValueState rejected THAT - the app died again,
                " one enum further along, after VISIBILITY was fixed.
                )->a( n = `items`         v = client->_bind( val = t_items
                                                             omit_initial_paths = temp1 )
                )->a( n = `mode`          v = `MultiSelect`
                )->a( n = `selectionChanged`  v = client->_event( val = `SELECTION` arg = `$event.oSource.getSelectedItems().length` )
                )->a( n = `afterItemRemoved`  v = client->_event( val = `REMOVED` arg = `${$parameters>/item}.getFileName()` )

                )->ele( n = `toolbar` ns = `upload`
                    )->ele( `OverflowToolbar`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `id`    v = `uploadSelectedButton`
                            )->a( n = `text`  v = `Upload selected`
                            )->a( n = `press` v = client->_event( `UPLOAD` )
                        )->tag( `Button`
                            )->a( n = `id`    v = `downloadSelectedButton`
                            )->a( n = `text`  v = `Download selected`
                            )->a( n = `press` v = client->_event( `DOWNLOAD` )
                        )->tag( `Button`
                            )->a( n = `id`      v = `versionButton`
                            )->a( n = `enabled` v = client->_bind( version_enabled )
                            )->a( n = `text`    v = `Upload a new version`
                            )->a( n = `press`   v = client->_event( `VERSION` )
                        )->tag( n = `UploadSetToolbarPlaceholder` ns = `upload`

                    )->end(
                )->end(
                )->ele( n = `items` ns = `upload`
                    )->ele( n = `UploadSetItem` ns = `upload`
                        )->a( n = `fileName`     v = `{FILENAME}`
                        )->a( n = `mediaType`    v = `{MEDIATYPE}`
                        )->a( n = `url`          v = `{URL}`
                        )->a( n = `thumbnailUrl` v = `{THUMBNAILURL}`
                        )->a( n = `markers`      v = `{MARKERS}`
                        )->a( n = `statuses`     v = `{STATUSES}`
                        )->a( n = `uploadState`  v = `{UPLOADSTATE}`

                        )->ele( n = `markers` ns = `upload`
                            )->tag( `ObjectMarker`
                                )->a( n = `type`       v = `{TYPE}`
                                )->a( n = `visibility` v = `{VISIBILITY}`

                        )->end(
                        )->ele( n = `statuses` ns = `upload`
                            )->tag( `ObjectStatus`
                                )->a( n = `title`  v = `{TITLE}`
                                )->a( n = `text`   v = `{TEXT}`
                                )->a( n = `state`  v = `{STATE}`
                                )->a( n = `icon`   v = `{ICON}`
                                )->a( n = `active` v = `{ACTIVE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE xsdboolean.

    CASE client->get_event( ).

      WHEN `SELECTION`.
        " onSelectionChange enables the version button for exactly one selected
        " item; the original raises no toast here
        
        temp1 = boolc( client->get_event_arg( ) = `1` ).
        version_enabled = temp1.

      WHEN `REMOVED`.
        " onAfterItemRemoved splices the row out of the model. The sample matches
        " on an id this row type does not carry, so the wire transports the file
        " name, which is unique across the two rows
        DELETE t_items WHERE filename = client->get_event_arg( ).

      WHEN `UPLOAD`.
        client->message_toast_display( `Upload selected pressed` ).

      WHEN `DOWNLOAD`.
        client->message_toast_display( `Download selected pressed` ).

      WHEN `VERSION`.
        client->message_toast_display( `Upload a new version pressed` ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the sample's own items.json, both rows verbatim - the asset URLs point at
    " the OpenUI5 host per the offline asset rule
    DATA temp3 LIKE t_items.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp1 TYPE z2ui5_cl_smpc_app_121=>ty_s_item-markers.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp5 TYPE z2ui5_cl_smpc_app_121=>ty_s_item-statuses.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_app_121=>ty_s_item-statuses.
    DATA temp8 LIKE LINE OF temp7.
    CLEAR temp3.
    
    temp4-filename = `Business Plan Agenda.doc`.
    temp4-mediatype = `application/msword`.
    temp4-url = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/UploadCollection/LinkedDocuments/Business Plan Agenda.doc`.
    temp4-uploadstate = `Complete`.
    
    CLEAR temp1.
    
    temp2-type = `Draft`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Favorite`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Flagged`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Locked`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Unsaved`.
    INSERT temp2 INTO TABLE temp1.
    temp4-markers = temp1.
    
    CLEAR temp5.
    
    temp6-title = `Uploaded By`.
    temp6-text = `Jane Burns`.
    temp6-active = abap_true.
    INSERT temp6 INTO TABLE temp5.
    temp6-title = `Uploaded On`.
    temp6-text = `2014-07-28`.
    temp6-active = abap_false.
    INSERT temp6 INTO TABLE temp5.
    temp6-title = `File Size`.
    temp6-text = `25`.
    temp6-active = abap_false.
    INSERT temp6 INTO TABLE temp5.
    temp6-title = `Document Info Record`.
    temp6-text = `SSP/101010101`.
    temp6-state = `Information`.
    INSERT temp6 INTO TABLE temp5.
    temp4-statuses = temp5.
    INSERT temp4 INTO TABLE temp3.
    temp4-filename = `Picture of a woman.png`.
    temp4-url = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`.
    temp4-thumbnailurl = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`.
    temp4-uploadstate = `Complete`.
    
    CLEAR temp7.
    
    temp8-title = `Uploaded By`.
    temp8-text = `Jane Burns`.
    temp8-active = abap_true.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Uploaded On`.
    temp8-text = `2014-07-28`.
    temp8-active = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp4-statuses = temp7.
    INSERT temp4 INTO TABLE temp3.
    t_items = temp3.

  ENDMETHOD.

ENDCLASS.
