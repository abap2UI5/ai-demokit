CLASS z2ui5_cl_ai_app_545 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA state TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_545 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the UI5 default of the enum-typed state property - an empty string would crash it
    state = `Clear`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( `Page`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `class`         v = `sapUiContentPadding`
            )->a( n = `showNavButton` v = `false`

            )->open( n = `VerticalLayout` ns = `l`
                )->open( n = `content` ns = `l`
                    )->leaf( `Button`
                        )->a( n = `id`    v = `setSavingDraft`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->a( n = `text`  v = `Set Saving Draft state`
                        )->a( n = `width` v = `200px`
                        )->a( n = `press` v = client->_event( `SET_SAVING_DRAFT` )
                    )->leaf( `Button`
                        )->a( n = `id`    v = `setSavedDraft`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->a( n = `text`  v = `Set Draft Saved state`
                        )->a( n = `width` v = `200px`
                        )->a( n = `press` v = client->_event( `SHOW_DRAFT_SAVED` )
                    )->leaf( `Button`
                        )->a( n = `id`    v = `setClearDraft`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->a( n = `text`  v = `Clear Draft state`
                        )->a( n = `width` v = `200px`
                        )->a( n = `press` v = client->_event( `CLEAR_DRAFT_STATE` )
                    " the controller's showDraftSaving/showDraftSaved/clearDraftState calls, expressed via the public state property (its setter queues the same transitions)
                    )->leaf( `DraftIndicator`
                        )->a( n = `id`    v = `draftIndi`
                        )->a( n = `state` v = client->_bind( state ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SET_SAVING_DRAFT`.
        state = `Saving`.
        client->view_model_update( ).

      WHEN `SHOW_DRAFT_SAVED`.
        state = `Saved`.
        client->view_model_update( ).

      WHEN `CLEAR_DRAFT_STATE`.
        state = `Clear`.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
