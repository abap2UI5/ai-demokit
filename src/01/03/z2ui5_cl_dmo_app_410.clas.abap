CLASS z2ui5_cl_dmo_app_410 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_410 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
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

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

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
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = css

        )->open( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->open( `headerTitle`
                )->leaf( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Eventing Blocks`

            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `example`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Example`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`

                                " sample:EventingBlock inlined
                                )->open( n = `VBox` ns = `m`
                                    )->a( n = `id`    v = `block`
                                    )->a( n = `class` v = `dummyContainer1`

                                    )->open( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `dummyContainer2`

                                        )->leaf( n = `Button` ns = `m`
                                            )->a( n = `text`  v = `press me to fire an event`
                                            )->a( n = `press` v = client->_event( val   = `DUMMY`
                                                                                  t_arg = VALUE #( ( `$event.oSource.getParent().getParent().sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `DUMMY`.
        " the main controller's onDummy toast, with the transported runtime id
        " of the block stand-in as the event source
        client->message_toast_display( |dummy event fired by control { client->get_event_arg( ) }| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
