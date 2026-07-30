CLASS z2ui5_cl_ai_app_249 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA badgemin       TYPE i.
    DATA badgemax       TYPE i.
    DATA badgecurrent   TYPE i.
    DATA buttontext     TYPE string.
    DATA buttonicon     TYPE string.
    DATA buttontype     TYPE string.
    DATA badgestyle     TYPE string.
    DATA buttonwithicon TYPE abap_bool.
    DATA buttonwithtext TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " the controller's clamped min/max mirrors (iMinValue/iMaxValue) - the
    " last ACCEPTED values an invalid entry is reset to
    DATA min_accepted TYPE i.
    DATA max_accepted TYPE i.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_249 IMPLEMENTATION.

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
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `height`       v = `100%`

        )->open( `Page`
            )->a( n = `title` v = `Button with Badge`

            )->open( `content`
                )->open( n = `VerticalLayout` ns = `layout`
                    )->a( n = `class` v = `sapUiContentPadding`
                    )->a( n = `width` v = `100%`

                    )->open( `Toolbar`
                        )->open( `content`
                            )->leaf( `Title`
                                )->a( n = `text` v = `Button`

                        )->shut(
                    )->shut(

                    )->open( `Button`
                        )->a( n = `id`         v = `BadgedButton`
                        )->a( n = `class`      v = `sapUiTinyMarginBeginEnd`
                        )->a( n = `icon`       v = |\{= ${ client->_bind( buttonwithicon ) } ? ${ client->_bind( buttonicon ) } : '' \}|
                        )->a( n = `type`       v = client->_bind( buttontype )
                        )->a( n = `badgeStyle` v = client->_bind( badgestyle )
                        )->a( n = `text`       v = |\{= ${ client->_bind( buttonwithtext ) } ? ${ client->_bind( buttontext ) } : '' \}|

                        )->open( `customData`
                            " the controller drove value via setValue from the StepInput; the
                            " thin-frontend form binds it to the same field (declared)
                            )->leaf( `BadgeCustomData`
                                )->a( n = `key`     v = `badge`
                                )->a( n = `value`   v = client->_bind( badgecurrent )
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->open( `Toolbar`
                        )->a( n = `class` v = `sapUiSmallMarginTop`
                        )->open( `content`
                            )->leaf( `Title`
                                )->a( n = `text` v = `Badge min, max and current values`

                        )->shut(
                    )->shut(

                    )->open( `FlexBox`
                        )->a( n = `class`          v = `sapUiTinyMarginBeginEnd`
                        )->a( n = `alignItems`     v = `Center`
                        )->a( n = `justifyContent` v = `Start`
                        )->leaf( `Text`
                            )->a( n = `renderWhitespace` v = `true`
                            )->a( n = `width`            v = `150px`
                            )->a( n = `text`             v = `Current badge value is `
                        )->leaf( `StepInput`
                            )->a( n = `id`    v = `CurrentValue`
                            )->a( n = `value` v = client->_bind( badgecurrent )
                            )->a( n = `width` v = `130px`

                    )->shut(

                    )->open( `FlexBox`
                        )->a( n = `class`          v = `sapUiTinyMarginBeginEnd`
                        )->a( n = `alignItems`     v = `Center`
                        )->a( n = `justifyContent` v = `Start`
                        )->leaf( `Text`
                            )->a( n = `renderWhitespace` v = `true`
                            )->a( n = `width`            v = `150px`
                            )->a( n = `text`             v = `Limit badge value from `
                        )->leaf( `Input`
                            )->a( n = `id`     v = `MinInput`
                            )->a( n = `value`  v = client->_bind( badgemin )
                            )->a( n = `width`  v = `55px`
                            )->a( n = `type`   v = `Number`
                            )->a( n = `change` v = client->_event( `MIN_CHANGE` )
                        )->leaf( `Text`
                            )->a( n = `renderWhitespace` v = `true`
                            )->a( n = `text`             v = ` to `
                        )->leaf( `Input`
                            )->a( n = `id`     v = `MaxInput`
                            )->a( n = `value`  v = client->_bind( badgemax )
                            )->a( n = `width`  v = `55px`
                            )->a( n = `type`   v = `Number`
                            )->a( n = `change` v = client->_event( `MAX_CHANGE` )

                    )->shut(
                    )->leaf( `Text`
                        )->a( n = `class`            v = `sapUiTinyMarginBeginEnd`
                        )->a( n = `renderWhitespace` v = `true`
                        )->a( n = `text`             v = `(fill something in 'from' and/or 'to' fields to test)`

                    )->open( `Toolbar`
                        )->a( n = `class` v = `sapUiSmallMarginTop`
                        )->open( `content`
                            )->leaf( `Title`
                                )->a( n = `text` v = `Button properties`

                        )->shut(
                    )->shut(

                    )->open( `FlexBox`
                        )->a( n = `class`          v = `sapUiTinyMarginBeginEnd`
                        )->a( n = `alignItems`     v = `Center`
                        )->a( n = `justifyContent` v = `Start`
                        )->leaf( `Text`
                            )->a( n = `renderWhitespace` v = `true`
                            )->a( n = `width`            v = `39px`
                            )->a( n = `text`             v = `Type  `

                        )->open( `Select`
                            )->a( n = `id`          v = `ButtonType`
                            )->a( n = `selectedKey` v = client->_bind( buttontype )
                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Default`
                                )->a( n = `text` v = `Default`
                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Ghost`
                                )->a( n = `text` v = `Ghost`
                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Transparent`
                                )->a( n = `text` v = `Transparent`
                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Emphasized`
                                )->a( n = `text` v = `Emphasized`

                        )->shut(
                    )->shut(

                    )->open( `FlexBox`
                        )->a( n = `class`          v = `sapUiTinyMarginBeginEnd`
                        )->a( n = `alignItems`     v = `Center`
                        )->a( n = `justifyContent` v = `Start`
                        )->leaf( `Text`
                            )->a( n = `renderWhitespace` v = `true`
                            )->a( n = `text`             v = `With `
                        )->leaf( `CheckBox`
                            )->a( n = `id`       v = `IconCheckBox`
                            )->a( n = `text`     v = `Icon`
                            )->a( n = `selected` v = client->_bind( buttonwithicon )
                        )->leaf( `CheckBox`
                            )->a( n = `id`       v = `TextCheckBox`
                            )->a( n = `text`     v = `Text`
                            )->a( n = `selected` v = client->_bind( buttonwithtext )

                    )->shut(

                    )->open( `FlexBox`
                        )->a( n = `class`          v = `sapUiTinyMarginBeginEnd`
                        )->a( n = `alignItems`     v = `Center`
                        )->a( n = `justifyContent` v = `Start`
                        )->leaf( `Text`
                            )->a( n = `renderWhitespace` v = `true`
                            )->a( n = `width`            v = `50px`
                            )->a( n = `text`             v = `Badge Style`

                        )->open( `Select`
                            )->a( n = `id`          v = `BadgeStyle`
                            )->a( n = `selectedKey` v = client->_bind( badgestyle )
                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Default`
                                )->a( n = `text` v = `Default`
                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Attention`
                                )->a( n = `text` v = `Attention`

                        )->shut(
                    )->shut(

                    )->open( `Toolbar`
                        )->a( n = `class` v = `sapUiSmallMarginTop`
                        )->open( `content`
                            )->leaf( `Title`
                                )->a( n = `text` v = `Notes`

                        )->shut(
                    )->shut(
                    )->leaf( `Text`
                        )->a( n = `class`    v = `sapUiTinyMargin`
                        )->a( n = `wrapping` v = `true`
                        )->a( n = `text`     v = `1. The value displayed in the Badge is controlled by the Button - if the value is below 1, the badge is hidden; if value is above the 9999, it is displayed as 999+`
                    )->leaf( `Text`
                        )->a( n = `class`    v = `sapUiTinyMargin`
                        )->a( n = `wrapping` v = `true`
                        )->a( n = `text`     v = `2. If an application developer wants to control more precisely the value and appearance of the Badge, ` &&
                                                   `that can be done as it is presented in this sample, but the constraints mentioned in (1) cannot be exceeded!`
                    )->leaf( `Text`
                        )->a( n = `class`    v = `sapUiTinyMargin`
                        )->a( n = `wrapping` v = `true`
                        )->a( n = `text`     v = `3. Badge can be used with all Button types, but it is recommended to use it only with the following Button types: Default, Ghost, Transparent and Emphasized.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `MIN_CHANGE`.
        " minChangeHandler: accept 1 <= min <= current max, else reset the
        " field to the last accepted value (business logic server-side)
        IF badgemin >= 1 AND badgemin <= max_accepted.
          min_accepted = badgemin.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `BadgedButton` ) ( `setBadgeMinValue` ) ( |{ badgemin }| ) ) ).
        ELSE.
          badgemin = min_accepted.
          client->view_model_update( ).
        ENDIF.

      WHEN `MAX_CHANGE`.
        " maxChangeHandler: accept min <= max <= 9999, else reset (the
        " original calls setBadgeMaxValue once before validating - a quirk
        " not copied; the accepted path is identical)
        IF badgemax <= 9999 AND badgemax >= min_accepted.
          max_accepted = badgemax.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `BadgedButton` ) ( `setBadgeMaxValue` ) ( |{ badgemax }| ) ) ).
        ELSE.
          badgemax = max_accepted.
          client->view_model_update( ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " onInit's model seed 1:1
    badgemin       = 1.
    badgemax       = 9999.
    badgecurrent   = 1.
    buttontext     = `Button with Badge`.
    buttonicon     = `sap-icon://cart`.
    buttontype     = `Default`.
    badgestyle     = `Default`.
    buttonwithicon = abap_true.
    buttonwithtext = abap_true.
    min_accepted   = 1.
    max_accepted   = 9999.

  ENDMETHOD.

ENDCLASS.
