CLASS z2ui5_cl_ai_app_121 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             filename     TYPE string,
             mediatype    TYPE string,
             url          TYPE string,
             thumbnailurl TYPE string,
           END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_121 IMPLEMENTATION.

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
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:upload` v = `sap.m.upload`
        )->a( n = `height`       v = `100%`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`

            )->open( n = `UploadSet` ns = `upload`
                )->a( n = `id`            v = `UploadSet`
                )->a( n = `instantUpload` v = `true`
                )->a( n = `showIcons`     v = `true`
                )->a( n = `uploadEnabled` v = `true`
                )->a( n = `fileTypes`     v = `txt,doc,png`
                )->a( n = `items`         v = client->_bind( t_items )
                )->a( n = `mode`          v = `MultiSelect`
                )->a( n = `selectionChanged`  v = client->_event( `SELECTION` )
                )->a( n = `afterItemRemoved`  v = client->_event( `REMOVED` )

                )->open( n = `toolbar` ns = `upload`
                    )->open( `OverflowToolbar`
                        )->leaf( `ToolbarSpacer`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Upload selected`
                            )->a( n = `press` v = client->_event( `UPLOAD` )

                )->shut(
                )->shut(
                )->open( n = `items` ns = `upload`
                    )->leaf( n = `UploadSetItem` ns = `upload`
                        )->a( n = `fileName`     v = `{FILENAME}`
                        )->a( n = `mediaType`    v = `{MEDIATYPE}`
                        )->a( n = `url`          v = `{URL}`
                        )->a( n = `thumbnailUrl` v = `{THUMBNAILURL}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SELECTION`.
        client->message_toast_display( `Selection changed` ).

      WHEN `REMOVED`.
        client->message_toast_display( `Item removed` ).

      WHEN `UPLOAD`.
        client->message_toast_display( `Upload selected pressed` ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    t_items = VALUE #(
      ( filename = `Screenshot.png` mediatype = `image/png` url = `` thumbnailurl = `sap-icon://document` )
      ( filename = `Notes.txt` mediatype = `text/plain` url = `` thumbnailurl = `sap-icon://document-text` )
      ( filename = `Report.doc` mediatype = `application/msword` url = `` thumbnailurl = `sap-icon://document` ) ).

  ENDMETHOD.

ENDCLASS.
