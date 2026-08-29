" @keywords blockbase block base sap.uxap blockbaseeventing html objectpagelayout objectpageheader objectpagesection objectpagesubsection vbox button
" @summary Uses of a block that is firing a dummy event
CLASS z2ui5_cl_smpc_app_410 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_410 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the sample's styles.css - the EventingBlock controller injects it as a
    " link element in onInit; here it is a core:HTML style tag (apps 026/028
    " idiom), literal braces escaped as \{ \} in a backtick literal because
    " the XMLView binding parser reads unescaped braces as a binding
    DATA(css) = `<style>.dummyContainer1\{padding:1em;height:4em;background-color:#A9EAFF\}` &&
                `.dummyContainer2\{display:inline-block\}</style>`.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block-content inlining (app 187/239/261 precedent): the blocks
    " aggregation holds the sample's own BlockBase control sample:EventingBlock
    " (id 'block'), a lazy-loading wrapper around the EventingBlock view whose
    " content is two nested html:div wrappers around a Button. A native div
    " cannot wrap a UI5 control via core:HTML, so each div becomes an m:VBox
    " carrying the same CSS class. The block declares a custom 'dummy' event
    " that its controller fires on the parent block from the Button press, and
    " the main controller answers with a toast naming the event source; that
    " two-hop indirection folds to one press wire, transporting the stand-in
    " outer VBox's runtime id, with the toast composed server-side in on_event.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = css

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->tag( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Eventing Blocks`

            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `example`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Example`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " sample:EventingBlock inlined
                                )->ele( n = `VBox` ns = `m`
                                    )->a( n = `id`    v = `block`
                                    )->a( n = `class` v = `dummyContainer1`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `dummyContainer2`

                                        )->tag( n = `Button` ns = `m`
                                            )->a( n = `text`  v = `press me to fire an event`
                                            )->a( n = `press` v = client->_event( val = `DUMMY` arg = `$event.oSource.getParent().getParent().sId` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `DUMMY`.
      " the main controller's onDummy toast, with the transported runtime id
      " of the block stand-in as the event source
      client->message_toast_display( |dummy event fired by control { client->get_event_arg( ) }| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
