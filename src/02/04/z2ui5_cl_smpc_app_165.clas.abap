" @keywords productswitch product switch sap.f productswitchnavigation verticallayout button text responsivepopover productswitchitem
" @summary This sample demonstrates the navigation behavior of Product Switch, configurable by the app developer.
CLASS z2ui5_cl_smpc_app_165 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             src       TYPE string,
             title     TYPE string,
             subtitle  TYPE string,
             targetsrc TYPE string,
             target    TYPE string,
           END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS model_init.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_165 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " The ProductSwitch itself is built in the sample's controller (fnOpen) and
    " shown in a popover; the shipped view is just the trigger button plus two
    " explanatory texts, rebuilt 1:1 here. The press raises a backend event and
    " on_event builds the same popover - the older claim that there is no JS
    " controller so the press only toasts was refuted on 2026-08-05 and had
    " been left standing in this comment until 2026-08-23.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `height`       v = `100%`

        )->ele( n = `VerticalLayout` ns = `layout`
            )->a( n = `class` v = `sapUiContentPadding`

            )->tag( `Button`
                )->a( n = `id`    v = `pSwitchBtn`
                )->a( n = `icon`  v = `sap-icon://menu`
                )->a( n = `text`  v = `Open Product Switch`
                " fnOpen loads ProductSwitchPopover.fragment.xml and opens it at this
                " button - rebuilt as a core:FragmentDefinition shown through
                " popover_display( by_id = ... ), the documented fragment-popover path
                )->a( n = `press` v = client->_event( `OPEN_SWITCH` )

            )->tag( `Text`
                )->a( n = `text` v = `Note: Redirection logic should be handled by the app developer.`

            )->tag( `Text`
                )->a( n = `text` v = `You can use sap.m.URLHelper, as shown in the fnChange method of the ProductSwitchNavigation controller.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA popover TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA temp1 TYPE string_table.
      DATA temp2 TYPE string_table.
      DATA temp3 LIKE LINE OF temp2.

    IF client->get_event( ) = `OPEN_SWITCH`.
      
      popover = z2ui5_cl_ui5_view_builder=>factory( ).

      
      CLEAR temp1.
      INSERT `MESSAGE_TOAST` INTO TABLE temp1.
      INSERT `show` INTO TABLE temp1.
      INSERT `Redirecting to {0}` INTO TABLE temp1.
      INSERT `${$parameters>/itemPressed}.getTargetSrc()` INTO TABLE temp1.
      
      CLEAR temp2.
      INSERT `REDIRECT` INTO TABLE temp2.
      
      temp3 = |\{ URL: $\{$parameters>/itemPressed\}.getTargetSrc(), NEW_WINDOW: true \}|.
      INSERT temp3 INTO TABLE temp2.
      popover->ele( n = `FragmentDefinition` ns = `core`
          )->a( n = `xmlns`      v = `sap.m`
          )->a( n = `xmlns:f`    v = `sap.f`
          )->a( n = `xmlns:core` v = `sap.ui.core`

          )->ele( `ResponsivePopover`
              )->a( n = `placement`  v = `Bottom`
              )->a( n = `showHeader` v = `false`

              " fnOpen gives the popover an Emphasized Close endButton on a
              " phone only, wired to the controller's closing handler. The
              " branch stays a branch: the button is declared once and its
              " visibility bound to the device model, the form apps 030/089
              " use, and closing is the roundtrip-free popover_close action.
              )->ele( `endButton`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Close`
                      )->a( n = `type`    v = `Emphasized`
                      )->a( n = `visible` v = |\{= $\{device>/system/phone\} \}|
                      )->a( n = `press`   v = client->follow_up_action( client->cs_event-popover_close )

              )->end(

              )->ele( n = `ProductSwitch` ns = `f`
                  )->a( n = `items`  v = client->_bind( t_items )
                  " fnChange toasts 'Redirecting to <targetSrc>' and calls
                  " URLHelper.redirect( targetSrc, true ) - both are client
                  " actions, chained on one event
                  )->a( n = `change` v = client->follow_up_action(
                            val   = client->cs_event-control_global
                            t_arg = temp1 ) && `; ` &&
                                        client->follow_up_action(
                            val   = client->cs_event-urlhelper
                            t_arg = temp2 )

                  )->ele( n = `items` ns = `f`
                      )->tag( n = `ProductSwitchItem` ns = `f`
                          )->a( n = `src`       v = `{SRC}`
                          )->a( n = `title`     v = `{TITLE}`
                          )->a( n = `subTitle`  v = `{SUBTITLE}`
                          )->a( n = `targetSrc` v = `{TARGETSRC}`
                          )->a( n = `target`    v = `{TARGET}` ).

      client->popover_display( xml = popover->stringify( ) by_id = `pSwitchBtn` ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " model/data.json, the three products the sample offers
    DATA temp3 LIKE t_items.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-target = `_blank`.
    temp4-src = `sap-icon://sap-logo-shape`.
    temp4-title = `SAP Homepage`.
    temp4-subtitle = `Learn more about SAP`.
    temp4-targetsrc = `https://www.sap.com/index.html`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://newspaper`.
    temp4-title = `Newsletter`.
    temp4-subtitle = `Subscribe to receive the latest UI5 updates`.
    temp4-targetsrc = `https://listserv.sap.com/mailman/listinfo/ui5.announce`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://group`.
    temp4-title = `Community`.
    temp4-subtitle = `Get involved`.
    temp4-targetsrc = `https://community.sap.com/topics/ui5`.
    INSERT temp4 INTO TABLE temp3.
    t_items = temp3.

  ENDMETHOD.

ENDCLASS.
