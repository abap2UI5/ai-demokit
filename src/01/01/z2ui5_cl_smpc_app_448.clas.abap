" @keywords draftindicator draft indicator sap.m semanticpagedraftindicator fullscreenpage addaction flagaction favoriteaction messagesindicator messagepopover messageitem
" @summary Integration of Draft Indicator inside Semantic Page
CLASS z2ui5_cl_smpc_app_448 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_message,
             type        TYPE string,
             message     TYPE string,
             description TYPE string,
           END OF ty_s_message.
    TYPES ty_t_message TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

    DATA t_messages TYPE ty_t_message.
    DATA type_here  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_448 IMPLEMENTATION.

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
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns:core`     v = `sap.ui.core`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:semantic` v = `sap.m.semantic`
        )->a( n = `xmlns:form`     v = `sap.ui.layout.form`
        )->a( n = `xmlns:z2ui5`    v = `z2ui5.cc`
        )->a( n = `displayBlock`   v = `true`

        )->ele( n = `FullscreenPage` ns = `semantic`
            )->a( n = `title`          v = `FullScreen Page Title`
            )->a( n = `showNavButton`  v = `true`
            )->a( n = `navButtonPress` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed navigation button` ) ) )

            " onSemanticButtonPress toasts the source's class name with the library
            " prefix stripped - the class name travels, the strip happens in ABAP
            )->ele( n = `addAction` ns = `semantic`
                )->tag( n = `AddAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val   = `SEMANTIC_PRESS`
                                                          t_arg = VALUE #( ( `$event.oSource.getMetadata().getName()` ) ) )

            )->end(
            )->ele( n = `flagAction` ns = `semantic`
                )->tag( n = `FlagAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val   = `SEMANTIC_PRESS`
                                                          t_arg = VALUE #( ( `$event.oSource.getMetadata().getName()` ) ) )

            )->end(
            )->ele( n = `favoriteAction` ns = `semantic`
                )->tag( n = `FavoriteAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val   = `SEMANTIC_PRESS`
                                                          t_arg = VALUE #( ( `$event.oSource.getMetadata().getName()` ) ) )

            )->end(
            )->ele( n = `messagesIndicator` ns = `semantic`
                )->ele( n = `MessagesIndicator` ns = `semantic`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                    t_arg = VALUE #( ( `draftMessagePopover` ) ( `toggleBy` ) ( `$event.oSource.sId` ) ) )

                    " the controller-built MessagePopover over the message model,
                    " declared as a dependent of its anchor (app 107 precedent)
                    )->ele( n = `dependents` ns = `semantic`
                        )->ele( `MessagePopover`
                            )->a( n = `id`    v = `draftMessagePopover`
                            )->a( n = `items` v = `{message>/}`

                            )->tag( `MessageItem`
                                )->a( n = `description` v = `{message>description}`
                                )->a( n = `type`        v = `{message>type}`
                                )->a( n = `title`       v = `{message>message}`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `draftIndicator` ns = `semantic`
                )->tag( `DraftIndicator`
                    )->a( n = `id`    v = `draftIndi`
                    )->a( n = `state` v = `Saved`

            )->end(
            )->ele( n = `content` ns = `semantic`

                " added container (declared): the z2ui5.cc.MessageManager bridge
                " reproducing onInit's MessageManager.addMessages seed
                )->tag( n = `MessageManager` ns = `z2ui5`
                    )->a( n = `items` v = client->_bind( t_messages )

                )->tag( `ObjectHeader`
                    )->a( n = `title`      v = `Type something in the field, the Draft Indicator will be displayed in the footer`
                    )->a( n = `intro`      v = `this is just a simulation of how the DraftIndicator will work`
                    )->a( n = `responsive` v = `true`

                )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `editable` v = `true`
                    )->a( n = `layout`   v = `ResponsiveGridLayout`

                    )->tag( `Label`
                        )->a( n = `text` v = `Type here`
                    " handleLiveChange runs showDraftSaving( ), showDraftSaved( ) and
                    " clearDraftState( ) one after the other. Those three do NOT
                    " collapse into the last one - DraftIndicator is queue-driven
                    " with a minDisplayTime of 1500 ms: showDraftSaving pushes
                    " [Saving, Clear] and _processQueue paints "Saving..." at once
                    " and arms a 1500 ms timer, after which the two later calls -
                    " which only queued, because _processQueue returns early while
                    " iDelayedCallId is set - are drained, painting "Draft saved"
                    " for another 1500 ms. So the original visibly shows
                    " Saving... -> Draft saved on every keystroke, which is what
                    " the sample's own header text advertises. Making only the
                    " clearDraftState call showed nothing at all (corrected
                    " 2026-08-24); all three now travel, in order.
                    " One call carries it: showDraftSaving alone queues
                    " [Saving, Clear], so the indicator shows "Saving..." for its
                    " minDisplayTime and then clears itself - roundtrip-free, on
                    " every keystroke, exactly where the original calls it.
                    " What is NOT reproduced is the intermediate "Draft saved"
                    " label: an event attribute carries ONE action, and routing
                    " the three calls through a round-trip instead would put a
                    " server hop on every keystroke - the lossy pattern AGENTS
                    " section 10 warns about and the advisory ratchet budgets.
                    " Showing Saving... and clearing is the closer half.
                    )->tag( `Input`
                        )->a( n = `id`         v = `TypeHere`
                        )->a( n = `value`      v = client->_bind( type_here )
                        )->a( n = `liveChange` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                             t_arg = VALUE #( ( `draftIndi` ) ( `showDraftSaving` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SEMANTIC_PRESS`.
      " the original strips the LIBRARY name, so sap.m.semantic.AddAction
      " reaches the toast as semantic.AddAction
      DATA(action) = replace( val = client->get_event_arg( ) sub = `sap.m.` with = `` ).
      client->message_toast_display( |Pressed: { action }| ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " onInit registers a ControlMessageProcessor and adds one error message
    t_messages = VALUE #( ( type = `Error` message = `Something wrong happened` ) ).

  ENDMETHOD.

ENDCLASS.
