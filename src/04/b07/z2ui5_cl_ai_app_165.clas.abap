CLASS z2ui5_cl_ai_app_165 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             src       TYPE string,
             title     TYPE string,
             subtitle  TYPE string,
             targetsrc TYPE string,
             target    TYPE string,
           END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS model_init.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_165 IMPLEMENTATION.

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

    " The ProductSwitch itself is built in the sample's controller (fnOpen) and
    " shown in a popover; the shipped view is just the trigger button plus two
    " explanatory texts, rebuilt 1:1 here. abap2UI5 has no JS controller, so the
    " button press raises a client toast in place of the controller-built popup.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `height`       v = `100%`

        )->open( n = `VerticalLayout` ns = `layout`
            )->a( n = `class` v = `sapUiContentPadding`

            )->leaf( `Button`
                )->a( n = `id`    v = `pSwitchBtn`
                )->a( n = `icon`  v = `sap-icon://menu`
                )->a( n = `text`  v = `Open Product Switch`
                " fnOpen loads ProductSwitchPopover.fragment.xml and opens it at this
                " button - rebuilt as a core:FragmentDefinition shown through
                " popover_display( by_id = ... ), the documented fragment-popover path
                )->a( n = `press` v = client->_event( `OPEN_SWITCH` )

            )->leaf( `Text`
                )->a( n = `text` v = `Note: Redirection logic should be handled by the app developer.`

            )->leaf( `Text`
                )->a( n = `text` v = `You can use sap.m.URLHelper, as shown in the fnChange method of the ProductSwitchNavigation controller.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_SWITCH`.
        DATA(popover) = z2ui5_cl_ai_xml=>factory( ).

        popover->open( n = `FragmentDefinition` ns = `core`
                )->a( n = `xmlns`      v = `sap.m`
                )->a( n = `xmlns:f`    v = `sap.f`
                )->a( n = `xmlns:core` v = `sap.ui.core`

                )->open( `ResponsivePopover`
                    )->a( n = `placement`  v = `Bottom`
                    )->a( n = `showHeader` v = `false`

                    )->open( n = `ProductSwitch` ns = `f`
                        )->a( n = `items`  v = client->_bind( t_items )
                        " fnChange toasts 'Redirecting to <targetSrc>' and calls
                        " URLHelper.redirect( targetSrc, true ) - both are client
                        " actions, chained on one event
                        )->a( n = `change` v = client->_event_client(
                                  val   = client->cs_event-control_global
                                  t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                   ( `show` )
                                                   ( `Redirecting to {0}` )
                                                   ( `${$parameters>/itemPressed}.getTargetSrc()` ) ) ) && `; ` &&
                                              client->_event_client(
                                  val   = client->cs_event-urlhelper
                                  t_arg = VALUE #( ( `REDIRECT` )
                                                   ( `\{ URL: ${$parameters>/itemPressed}.getTargetSrc(), NEW_WINDOW: true \}` ) ) )

                        )->open( n = `items` ns = `f`
                            )->leaf( n = `ProductSwitchItem` ns = `f`
                                )->a( n = `src`       v = `{SRC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `subTitle`  v = `{SUBTITLE}`
                                )->a( n = `targetSrc` v = `{TARGETSRC}`
                                )->a( n = `target`    v = `{TARGET}` ).

        client->popover_display( xml   = popover->stringify( )
                                 by_id = `pSwitchBtn` ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " model/data.json, the three products the sample offers
    t_items = VALUE #(
      target = `_blank`
      ( src = `sap-icon://sap-logo-shape` title = `SAP Homepage` subtitle = `Learn more about SAP`
        targetsrc = `https://www.sap.com/index.html` )
      ( src = `sap-icon://newspaper` title = `Newsletter` subtitle = `Subscribe to receive the latest UI5 updates`
        targetsrc = `https://listserv.sap.com/mailman/listinfo/ui5.announce` )
      ( src = `sap-icon://group` title = `Community` subtitle = `Get involved`
        targetsrc = `https://community.sap.com/topics/ui5` ) ).

  ENDMETHOD.

ENDCLASS.
