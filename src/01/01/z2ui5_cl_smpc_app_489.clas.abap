" @keywords segmentedbutton segmented button sap.m segmentedbuttondialog verticallayout dialog segmentedbuttonitem
" @summary Segmented Button used in Dialog component
CLASS z2ui5_cl_smpc_app_489 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_dialog_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_489 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Button`
                )->a( n = `text`  v = `Open Dialog`
                )->a( n = `press` v = client->_event( `DIALOG_OPEN` )
                )->a( n = `class` v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `DIALOG_OPEN`.
      popup_dialog_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD popup_dialog_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Dialog`
            )->a( n = `id`    v = `myDialog`
            )->a( n = `title` v = `Dialog with Segmented Button`
            )->a( n = `class` v = `sapUiContentPadding`

            )->ele( `SegmentedButton`
                )->a( n = `selectedKey` v = `SBApproved`
                )->a( n = `width`       v = `100%`

                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `Approved`
                        )->a( n = `key`  v = `SBApproved`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `Rejected`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `Lookup`

                )->end(
            )->end(

            )->ele( `beginButton`
                " onCloseDialog is a plain dialog.close( ) - the client-side popup_close
                )->tag( `Button`
                    )->a( n = `text`  v = `Close`
                    )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
