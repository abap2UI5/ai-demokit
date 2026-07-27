CLASS z2ui5_cl_ai_app_252 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    " THIS PATH IS A PLACEHOLDER AND MUST BE REPLACED - the app shows an empty
    " chart until it points at a real service.
    " Unlike its four neighbours in this package, the SmartChart cannot fall back
    " to the Gateway demo service GWSAMPLE_BASIC: it needs an ANALYTICAL OData V2
    " service - properties marked sap:aggregation-role dimension/measure plus the
    " UI.Chart annotation the chart layout comes from (see the sample's own
    " metadata.xml, archived in ui5/sap.ui.comp/SmartChart/). No such service is
    " part of any standard system, so there is no honest default to ship here;
    " enter the analytical service of your system, with an entity set carrying
    " the dimensions and measures the view expects.
    CONSTANTS c_odata_service TYPE string VALUE `/sap/opu/odata/sap/<YOUR_ANALYTICAL_SERVICE>/`.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_252 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The chart, its dimensions/measures and the personalization dialog are all
    " metadata-driven; the SemanticObjectController turns the annotated
    " Category dimension into a navigation popover and reports its two events
    " back to the backend.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`            v = `sap.m`
        )->a( n = `xmlns:mvc`        v = `sap.ui.core.mvc`
        )->a( n = `xmlns:html`       v = `http://www.w3.org/1999/xhtml`
        )->a( n = `xmlns:app`        v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.CustomData/1`
        )->a( n = `xmlns:sl`         v = `sap.ui.comp.navpopover`
        )->a( n = `xmlns:smartChart` v = `sap.ui.comp.smartchart`

        )->open( n = `SmartChart` ns = `smartChart`
            )->a( n = `enableAutoBinding`       v = `true`
            )->a( n = `entitySet`               v = `Products`
            )->a( n = `useVariantManagement`    v = `true`
            )->a( n = `persistencyKey`          v = `SmartChart_Explored`
            )->a( n = `useChartPersonalisation` v = `true`
            )->a( n = `header`                  v = `Products`

            )->open( n = `semanticObjectController` ns = `smartChart`
                )->leaf( n = `SemanticObjectController` ns = `sl`
                    )->a( n = `navigationTargetsObtained` v = client->_event( `NAV_TARGETS_OBTAINED` )
                    )->a( n = `navigate`                  v = client->_event( val   = `NAVIGATE`
                                                                              t_arg = VALUE #( ( `${$parameters>/text}` ) ) ) ).

    client->view_display( val                       = view->stringify( )
                          switch_default_model_path = c_odata_service ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `NAV_TARGETS_OBTAINED`.
        " The original controller answers this event by composing the navigation
        " popover imperatively (oParameters.show(...) with LinkData entries and a
        " SimpleForm of Title/Image/Text). That is frontend construction of
        " controls, which a thin frontend cannot express - the port keeps the
        " event wired and leaves the popover at the content the
        " SemanticObjectController derives from the annotations itself.
        client->message_toast_display( `Navigation targets obtained` ).

      WHEN `NAVIGATE`.
        " 1:1 with the original onNavigate: the Homepage link navigates and is
        " not commented, every other link raises the message box.
        DATA(text) = client->get_event_arg( ).
        IF text <> `Homepage`.
          client->message_box_display( text  = |{ text } has been pressed|
                                       type  = `information`
                                       title = `SmartChart demo` ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
