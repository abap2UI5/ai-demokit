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
             markers      TYPE STANDARD TABLE OF ty_s_marker WITH EMPTY KEY,
             statuses     TYPE STANDARD TABLE OF ty_s_status WITH EMPTY KEY,
           END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

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
    IF client->check_on_init( ).
      model_init( ).
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
                                                             omit_initial_paths = VALUE #( ( `VISIBILITY` )
                                                                                          ( `STATE` )
                                                                                          ( `ICON` ) ) )
                )->a( n = `mode`          v = `MultiSelect`
                )->a( n = `selectionChanged`  v = client->_event( `SELECTION` )
                )->a( n = `afterItemRemoved`  v = client->_event( `REMOVED` )

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
                            )->a( n = `enabled` v = `false`
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

    CASE client->get_event( ).

      WHEN `SELECTION`.
        client->message_toast_display( `Selection changed` ).

      WHEN `REMOVED`.
        client->message_toast_display( `Item removed` ).

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
    t_items = VALUE #(
      ( filename    = `Business Plan Agenda.doc`
        mediatype   = `application/msword`
        url         = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/UploadCollection/LinkedDocuments/Business Plan Agenda.doc`
        uploadstate = `Complete`
        markers     = VALUE #( ( type = `Draft` ) ( type = `Favorite` ) ( type = `Flagged` )
                               ( type = `Locked` ) ( type = `Unsaved` ) )
        statuses    = VALUE #( ( title = `Uploaded By` text = `Jane Burns` active = abap_true )
                               ( title = `Uploaded On` text = `2014-07-28` active = abap_false )
                               ( title = `File Size` text = `25` active = abap_false )
                               ( title = `Document Info Record` text = `SSP/101010101` state = `Information` ) ) )
      ( filename     = `Picture of a woman.png`
        mediatype    = `image/png`
        url          = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`
        thumbnailurl = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`
        uploadstate  = `Complete`
        statuses     = VALUE #( ( title = `Uploaded By` text = `Jane Burns` active = abap_true )
                                ( title = `Uploaded On` text = `2014-07-28` active = abap_false ) ) ) ).

  ENDMETHOD.

ENDCLASS.
