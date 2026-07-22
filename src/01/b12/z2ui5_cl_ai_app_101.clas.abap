CLASS z2ui5_cl_ai_app_101 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product_type TYPE string.
    DATA product_name TYPE string.
    DATA product_name_state TYPE string.
    DATA product_weight TYPE string.
    DATA product_weight_state TYPE string.
    DATA product_manufacturer TYPE string.
    DATA product_description TYPE string.
    DATA manufacturing_date TYPE string.
    DATA availability_type TYPE string.
    DATA size TYPE string.
    DATA measurement TYPE string.
    DATA product_price TYPE string.
    DATA discount_group TYPE string.
    DATA product_vat TYPE abap_bool.
    DATA step2_validated TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS edit_step IMPORTING step_id TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_101 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`
        )->a( n = `height`     v = `100%`

        )->open( `NavContainer`
            )->a( n = `id` v = `wizardNavContainer`

            )->open( `pages`
                )->open( `Page`
                    )->a( n = `id`         v = `wizardContentPage`
                    )->a( n = `showHeader` v = `false`

                    )->open( `content`
                        )->open( `Wizard`
                            )->a( n = `id`       v = `CreateProductWizard`
                            )->a( n = `class`    v = `sapUiResponsivePadding--header sapUiResponsivePadding--content`
                            )->a( n = `complete` v = client->_event( `WIZARD_COMPLETE` )

                            )->open( `WizardStep`
                                )->a( n = `id`        v = `ProductTypeStep`
                                )->a( n = `title`     v = `Product Type`
                                )->a( n = `validated` v = `true`

                                )->leaf( `MessageStrip`
                                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                    )->a( n = `text`     v = `The Wizard control is supposed to break down large tasks, into smaller steps, easier for the user to work with.`
                                    )->a( n = `showIcon` v = `true`
                                )->leaf( `Text`
                                    )->a( n = `class` v = `sapUiSmallMarginBottom`
                                    )->a( n = `text`  v = `Sed fermentum, mi et tristique ullamcorper, sapien sapien faucibus sem, quis pretium nibh lorem malesuada diam. ` &&
                                                          `Nulla quis arcu aliquet, feugiat massa semper, volutpat diam. Nam vitae ante posuere, molestie neque sit amet, dapibus velit. ` &&
                                                          `Maecenas eleifend tempor lorem. Mauris vitae elementum mi, sed eleifend ligula. Nulla tempor vulputate dolor, nec dignissim quam convallis ut. ` &&
                                                          `Praesent vitae commodo felis, ut iaculis felis. Fusce quis eleifend sapien, eget facilisis nibh. Suspendisse est velit, scelerisque ut commodo eget, dignissim quis metus. ` &&
                                                          `Cras faucibus consequat gravida. Curabitur vitae quam felis. Phasellus ac leo eleifend, commodo tortor et, varius quam. Aliquam erat volutpat`

                                )->open( `HBox`
                                    )->a( n = `alignItems`      v = `Center`
                                    )->a( n = `justifyContent`  v = `Center`
                                    )->a( n = `width`           v = `100%`

                                    )->open( `SegmentedButton`
                                        )->a( n = `width`           v = `320px`
                                        )->a( n = `selectedKey`     v = client->_bind( product_type )
                                        )->a( n = `selectionChange` v = client->_event( `SET_PRODUCT_TYPE` )

                                        )->open( `items`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `icon` v = `sap-icon://iphone`
                                                )->a( n = `text` v = `Mobile`
                                                )->a( n = `key`  v = `Mobile`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `icon` v = `sap-icon://sys-monitor`
                                                )->a( n = `text` v = `Desktop`
                                                )->a( n = `key`  v = `Desktop`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `icon` v = `sap-icon://database`
                                                )->a( n = `text` v = `Other`
                                                )->a( n = `key`  v = `Other`

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(

                            )->open( `WizardStep`
                                )->a( n = `id`        v = `ProductInfoStep`
                                )->a( n = `validated` v = client->_bind( step2_validated )
                                )->a( n = `title`     v = `Product Information`
                                )->a( n = `activate`  v = client->_event( `ADDITIONAL_INFO` )

                                )->leaf( `MessageStrip`
                                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                    )->a( n = `text`     v = `Validation in the wizard is controlled by calling the validateStep(Step) and invalidateStep(Step) methods `
                                    )->a( n = `showIcon` v = `true`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `Cras tellus leo, volutpat vitae ullamcorper eu, posuere malesuada nisl. Integer pellentesque leo sit amet dui vehicula, quis ullamcorper est pulvinar. ` &&
                                                        `Nam in libero sem. Suspendisse arcu metus, molestie a turpis a, molestie aliquet dui. Donec pulvinar, sapien et viverra imperdiet, orci erat porttitor nulla, ` &&
                                                        `eget commodo metus nibh nec ipsum. Aliquam lacinia euismod metus, sollicitudin pellentesque purus volutpat eget. Pellentesque egestas erat quis eros convallis mattis.`

                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `true`
                                    )->a( n = `layout`   v = `ResponsiveGridLayout`

                                    )->leaf( `Label`
                                        )->a( n = `text`     v = `Name`
                                        )->a( n = `required` v = `true`
                                    )->leaf( `Input`
                                        )->a( n = `valueStateText` v = `Enter 6 symbols or more`
                                        )->a( n = `valueState`     v = client->_bind( product_name_state )
                                        )->a( n = `id`             v = `ProductName`
                                        )->a( n = `liveChange`     v = client->_event( `ADDITIONAL_INFO` )
                                        )->a( n = `placeholder`    v = `Enter name with length greater than 6`
                                        )->a( n = `value`          v = client->_bind( product_name )
                                    )->leaf( `Label`
                                        )->a( n = `text`     v = `Weight`
                                        )->a( n = `required` v = `true`
                                    )->leaf( `Input`
                                        )->a( n = `valueStateText` v = `Enter digits`
                                        )->a( n = `valueState`     v = client->_bind( product_weight_state )
                                        )->a( n = `id`             v = `ProductWeight`
                                        )->a( n = `liveChange`     v = client->_event( `ADDITIONAL_INFO` )
                                        )->a( n = `type`           v = `Number`
                                        )->a( n = `placeholder`    v = `Enter digits`
                                        )->a( n = `value`          v = client->_bind( product_weight )
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Manufacturer`

                                    )->open( `Select`
                                        )->a( n = `selectedKey` v = client->_bind( product_manufacturer )

                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Apple`
                                            )->a( n = `text` v = `Apple`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Microsoft`
                                            )->a( n = `text` v = `Microsoft`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Google`
                                            )->a( n = `text` v = `Google`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Sony`
                                            )->a( n = `text` v = `Sony`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Samsung`
                                            )->a( n = `text` v = `Samsung`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Logitech`
                                            )->a( n = `text` v = `Logitech`

                                    )->shut(
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Description`
                                    )->leaf( `TextArea`
                                        )->a( n = `value` v = client->_bind( product_description )
                                        )->a( n = `rows`  v = `8`

                                )->shut(
                            )->shut(

                            )->open( `WizardStep`
                                )->a( n = `id`        v = `OptionalInfoStep`
                                )->a( n = `validated` v = `true`
                                )->a( n = `activate`  v = client->_event( `OPTIONAL_ACTIVATE` )
                                )->a( n = `title`     v = `Optional Information`

                                )->leaf( `MessageStrip`
                                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                    )->a( n = `text`     v = `You can validate steps by default with the validated='true' property of the step. The next button is always enabled.`
                                    )->a( n = `showIcon` v = `true`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `Integer pellentesque leo sit amet dui vehicula, quis ullamcorper est pulvinar. Nam in libero sem. Suspendisse arcu metus, molestie a turpis a, molestie aliquet dui. ` &&
                                                        `Donec pellentesque leo sit amet dui vehicula, quis ullamcorper est pulvinar. Nam in libero sem. Suspendisse arcu metus, molestie a turpis a, molestie aliquet dui. ` &&
                                                        `Donec pulvinar, sapien corper eu, posuere malesuada nisl.`

                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `true`
                                    )->a( n = `layout`   v = `ResponsiveGridLayout`

                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Cover photo`
                                    )->leaf( n = `FileUploader` ns = `u`
                                        )->a( n = `width`       v = `100%`
                                        )->a( n = `tooltip`     v = `Upload product cover photo to the local server`
                                        )->a( n = `style`       v = `Emphasized`
                                        )->a( n = `placeholder` v = `Choose a file for Upload...`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Manufacturing date`
                                    )->leaf( `DatePicker`
                                        )->a( n = `id`            v = `DP3`
                                        )->a( n = `displayFormat` v = `short`
                                        )->a( n = `value`         v = client->_bind( manufacturing_date )
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Availability`

                                    )->open( `SegmentedButton`
                                        )->a( n = `selectedKey` v = client->_bind( availability_type )

                                        )->open( `items`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `key`  v = `In store`
                                                )->a( n = `text` v = `In store`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `key`  v = `In depot`
                                                )->a( n = `text` v = `In depot`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `key`  v = `In repository`
                                                )->a( n = `text` v = `In repository`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `key`  v = `Out of stock`
                                                )->a( n = `text` v = `Out of stock`

                                        )->shut(
                                    )->shut(
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Size`
                                    )->leaf( `Input`
                                        )->a( n = `value` v = client->_bind( size )

                                    )->open( `ComboBox`
                                        )->a( n = `maxWidth`    v = `100px`
                                        )->a( n = `selectedKey` v = client->_bind( measurement )

                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `X`
                                            )->a( n = `text` v = `X`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Y`
                                            )->a( n = `text` v = `Y`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Z`
                                            )->a( n = `text` v = `Z`

                                    )->shut(
                                )->shut(
                            )->shut(

                            )->open( `WizardStep`
                                )->a( n = `id`        v = `PricingStep`
                                )->a( n = `activate`  v = client->_event( `PRICING_ACTIVATE` )
                                )->a( n = `complete`  v = client->_event( `PRICING_COMPLETE` )
                                )->a( n = `validated` v = `true`
                                )->a( n = `title`     v = `Pricing`

                                )->leaf( `MessageStrip`
                                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                    )->a( n = `text`     v = `You can use the wizard previousStep() and nextStep() methods to navigate from step to step without validation. ` &&
                                                            `Also you can use the GoToStep(step) method to scroll programmatically to previously visited steps.`
                                    )->a( n = `showIcon` v = `true`

                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `true`
                                    )->a( n = `layout`   v = `ResponsiveGridLayout`

                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Price`
                                    )->leaf( `Input`
                                        )->a( n = `value` v = client->_bind( product_price )
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Discount group`

                                    )->open( `ComboBox`
                                        )->a( n = `selectedKey` v = client->_bind( discount_group )

                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Kids`
                                            )->a( n = `text` v = `Kids`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Teens`
                                            )->a( n = `text` v = `Teens`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Adults`
                                            )->a( n = `text` v = `Adults`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `Elderly`
                                            )->a( n = `text` v = `Elderly`

                                    )->shut(
                                    )->leaf( `Label`
                                        )->a( n = `text` v = ` VAT is included`
                                    )->leaf( `CheckBox`
                                        )->a( n = `selected` v = client->_bind( product_vat )

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `footer`
                        )->open( `OverflowToolbar`
                            )->leaf( `ToolbarSpacer`
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Cancel`
                                )->a( n = `press` v = client->_event( `WIZARD_CANCEL` )

                        )->shut(
                    )->shut(
                )->shut(
                )->open( `Page`
                    )->a( n = `id`         v = `wizardReviewPage`
                    )->a( n = `showHeader` v = `false`

                    )->open( `content`
                        )->open( n = `SimpleForm` ns = `form`
                            )->a( n = `title`    v = `1. Product Type`
                            )->a( n = `editable` v = `false`
                            )->a( n = `layout`   v = `ResponsiveGridLayout`

                            )->open( n = `content` ns = `form`
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Type`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `ProductTypeChosen`
                                    )->a( n = `text` v = client->_bind( product_type )
                                )->leaf( `Link`
                                    )->a( n = `press` v = client->_event( `EDIT_STEP_1` )
                                    )->a( n = `text`  v = `Edit`

                        )->shut(
                        )->shut(
                        )->open( n = `SimpleForm` ns = `form`
                            )->a( n = `title`    v = `2. Product Information`
                            )->a( n = `editable` v = `false`
                            )->a( n = `layout`   v = `ResponsiveGridLayout`

                            )->open( n = `content` ns = `form`
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Name`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `ProductNameChosen`
                                    )->a( n = `text` v = client->_bind( product_name )
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Weight`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `ProductWeightChosen`
                                    )->a( n = `text` v = client->_bind( product_weight )
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Manufacturer`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `ProductManufacturerChosen`
                                    )->a( n = `text` v = client->_bind( product_manufacturer )
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Description`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `ProductDescriptionChosen`
                                    )->a( n = `text` v = client->_bind( product_description )
                                )->leaf( `Link`
                                    )->a( n = `press` v = client->_event( `EDIT_STEP_2` )
                                    )->a( n = `text`  v = `Edit`

                        )->shut(
                        )->shut(
                        )->open( n = `SimpleForm` ns = `form`
                            )->a( n = `title`    v = `3. Optional Information`
                            )->a( n = `editable` v = `false`
                            )->a( n = `layout`   v = `ResponsiveGridLayout`

                            )->open( n = `content` ns = `form`
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Some text`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. `

                                )->leaf( `Label`
                                    )->a( n = `text` v = `Manufacturing Date`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `ManufacturingDate`
                                    )->a( n = `text` v = client->_bind( manufacturing_date )
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Availability`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `AvailabilityChosen`
                                    )->a( n = `text` v = client->_bind( availability_type )
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Size`

                                )->open( `HBox`
                                    )->leaf( `Text`
                                        )->a( n = `id`   v = `Size`
                                        )->a( n = `text` v = client->_bind( size )
                                    )->leaf( `Text`
                                        )->a( n = `id`    v = `Size2`
                                        )->a( n = `class` v = `sapUiTinyMarginBegin`
                                        )->a( n = `text`  v = client->_bind( measurement )

                                )->shut(
                                )->leaf( `Link`
                                    )->a( n = `press` v = client->_event( `EDIT_STEP_3` )
                                    )->a( n = `text`  v = `Edit`

                        )->shut(
                        )->shut(
                        )->open( n = `SimpleForm` ns = `form`
                            )->a( n = `title`    v = `4. Pricing`
                            )->a( n = `editable` v = `false`
                            )->a( n = `layout`   v = `ResponsiveGridLayout`

                            )->open( n = `content` ns = `form`
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Price`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `ProductPriceChosen`
                                    )->a( n = `text` v = client->_bind( product_price )
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Discount Group`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `DiscountGroupChosen`
                                    )->a( n = `text` v = client->_bind( discount_group )
                                )->leaf( `Label`
                                    )->a( n = `text` v = `VAT Included`
                                )->leaf( `Text`
                                    )->a( n = `id`   v = `ProductVATChosen`
                                    )->a( n = `text` v = client->_bind( product_vat )
                                )->leaf( `Link`
                                    )->a( n = `press` v = client->_event( `EDIT_STEP_4` )
                                    )->a( n = `text`  v = `Edit`

                        )->shut(
                        )->shut(
                    )->shut(
                    )->open( `footer`
                        )->open( `Bar`
                            )->open( `contentRight`
                                )->leaf( `Button`
                                    )->a( n = `text`  v = `Submit`
                                    )->a( n = `press` v = client->_event( `WIZARD_SUBMIT` )
                                )->leaf( `Button`
                                    )->a( n = `text`  v = `Cancel`
                                    )->a( n = `press` v = client->_event( `WIZARD_CANCEL` )

                        )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `ADDITIONAL_INFO`.
        " reproduces additionalInfoValidation: name >= 6 chars, weight numeric
        DATA(name_ok)   = xsdbool( strlen( product_name ) >= 6 ).
        DATA(weight_ok) = xsdbool( product_weight CO `0123456789` AND product_weight IS NOT INITIAL ).
        product_name_state   = COND #( WHEN name_ok = abap_true THEN `None` ELSE `Error` ).
        product_weight_state = COND #( WHEN weight_ok = abap_true THEN `None` ELSE `Error` ).
        step2_validated      = xsdbool( name_ok = abap_true AND weight_ok = abap_true ).
        client->view_model_update( ).

      WHEN `OPTIONAL_ACTIVATE`.
        client->message_toast_display( `This event is fired on activate of Step3.` ).

      WHEN `WIZARD_COMPLETE`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `wizardNavContainer` ) ( `to` ) ( `wizardReviewPage` ) ) ).

      WHEN `EDIT_STEP_1`.
        edit_step( `ProductTypeStep` ).

      WHEN `EDIT_STEP_2`.
        edit_step( `ProductInfoStep` ).

      WHEN `EDIT_STEP_3`.
        edit_step( `OptionalInfoStep` ).

      WHEN `EDIT_STEP_4`.
        edit_step( `PricingStep` ).

      WHEN `WIZARD_CANCEL`.
        client->message_box_display( text    = `Are you sure you want to cancel your report?`
                                     type    = `warning`
                                     actions = VALUE #( ( `YES` ) ( `NO` ) )
                                     onclose = `CANCEL_CLOSED` ).

      WHEN `WIZARD_SUBMIT`.
        client->message_box_display( text    = `Are you sure you want to submit your report?`
                                     type    = `confirm`
                                     actions = VALUE #( ( `YES` ) ( `NO` ) )
                                     onclose = `CANCEL_CLOSED` ).

      WHEN `CANCEL_CLOSED`.
        IF client->get_event_arg( ) = `YES`.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `wizardNavContainer` ) ( `to` ) ( `wizardContentPage` ) ) ).
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `CreateProductWizard` ) ( `discardProgress` ) ( `ProductTypeStep` ) ) ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD edit_step.

    " original _handleNavigationToStep: back to the wizard content page, then goToStep
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( `wizardNavContainer` ) ( `to` ) ( `wizardContentPage` ) ) ).
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( `CreateProductWizard` ) ( `goToStep` ) ( step_id ) ) ).

  ENDMETHOD.


  METHOD model_init.

    product_name_state   = `Error`.
    product_weight_state = `Error`.
    product_type         = `Mobile`.
    availability_type    = `In Store`.
    product_vat          = abap_false.
    measurement          = ``.
    product_manufacturer = `n/a`.
    product_description  = `n/a`.
    size                 = `n/a`.
    product_price        = `n/a`.
    manufacturing_date   = `n/a`.
    discount_group       = `n/a`.

  ENDMETHOD.

ENDCLASS.
