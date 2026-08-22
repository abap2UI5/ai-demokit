CLASS z2ui5_cl_smpc_app_533 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product_type         TYPE string.
    DATA product_name         TYPE string.
    DATA product_name_state   TYPE string.
    DATA product_weight       TYPE string.
    DATA product_weight_state TYPE string.
    DATA product_manufacturer TYPE string.
    DATA product_description  TYPE string.
    DATA manufacturing_date   TYPE string.
    DATA availability_type    TYPE string.
    DATA size                 TYPE string.
    DATA measurement          TYPE string.
    DATA product_price        TYPE string.
    DATA discount_group       TYPE string.
    DATA product_vat          TYPE abap_bool.
    DATA step2_validated      TYPE abap_bool.
    DATA next_enabled         TYPE abap_bool VALUE abap_true.
    DATA current_step         TYPE string.
    DATA step_index           TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_wizard_display.
    METHODS step_goto IMPORTING index TYPE i.
    METHODS info_validate.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_533 IMPLEMENTATION.

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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->tag( `Button`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->a( n = `text`  v = `Open Wizard in Dialog`
            )->a( n = `press` v = client->_event( `OPEN_DIALOG` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_wizard_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    " handleButtonsVisibility switches the five footer buttons on the SELECTED
    " STEP INDEX; the index is one bound field here and each button carries the
    " same condition as an expression binding
    DATA(v_back) = |\{= ${ client->_bind( step_index ) } > 0 && ${ client->_bind( step_index ) } < 4 \}|.
    DATA(v_next) = |\{= ${ client->_bind( step_index ) } < 3 \}|.
    DATA(v_rev)  = |\{= ${ client->_bind( step_index ) } === 3 \}|.
    DATA(v_fin)  = |\{= ${ client->_bind( step_index ) } === 4 \}|.

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`

        )->ele( `Dialog`
            )->a( n = `id`                v = `wizardDialog`
            )->a( n = `showHeader`        v = `false`
            )->a( n = `verticalScrolling` v = `false`
            )->a( n = `contentHeight`     v = `70%`
            )->a( n = `contentWidth`      v = `80%`

            )->ele( n = `DynamicPage` ns = `f`
                )->a( n = `stickySubheaderProvider`  v = `CreateProductWizard`
                )->a( n = `toggleHeaderOnTitleClick` v = `false`
                )->a( n = `class`                    v = `sapUiNoContentPadding`
                )->a( n = `showFooter`               v = `true`

                )->ele( n = `title` ns = `f`
                    )->ele( n = `DynamicPageTitle` ns = `f`
                        )->ele( n = `heading` ns = `f`
                            )->tag( `Title`
                                )->a( n = `text` v = `Wizard in a Dialog`

                        )->end(
                    )->end(
                )->end(

                )->ele( n = `content` ns = `f`
                    )->ele( `Wizard`
                        )->a( n = `id`               v = `CreateProductWizard`
                        )->a( n = `class`            v = `sapUiResponsivePadding--header sapUiResponsivePadding--content`
                        )->a( n = `showNextButton`   v = `false`
                        )->a( n = `renderMode`       v = `Page`
                        " handleNavigationChange reads the step off the event and
                        " recomputes the index; the step TITLE travels here
                        )->a( n = `navigationChange` v = client->_event( val   = `NAVIGATION_CHANGE`
                                                                         t_arg = VALUE #( ( `${$parameters>/step}.getTitle()` ) ) )

                        )->ele( `WizardStep`
                            )->a( n = `id`        v = `ProductTypeStep`
                            )->a( n = `title`     v = `Product Type`
                            )->a( n = `validated` v = `true`

                            )->tag( `MessageStrip`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `The Wizard control is supposed to break down large tasks, into smaller steps, easier for the user to work with.`
                                )->a( n = `showIcon` v = `true`
                            )->tag( `Text`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Sed fermentum, mi et tristique ullamcorper, sapien sapien faucibus sem, quis pretium nibh lorem malesuada diam. ` &&
                                                      `Nulla quis arcu aliquet, feugiat massa semper, volutpat diam. Nam vitae ante posuere, molestie neque sit amet, dapibus velit. ` &&
                                                      `Maecenas eleifend tempor lorem. Mauris vitae elementum mi, sed eleifend ligula. Nulla tempor vulputate dolor, nec dignissim quam convallis ut. ` &&
                                                      `Praesent vitae commodo felis, ut iaculis felis. Fusce quis eleifend sapien, eget facilisis nibh. Suspendisse est velit, scelerisque ut commodo eget, dignissim quis metus. ` &&
                                                      `Cras faucibus consequat gravida. Curabitur vitae quam felis. Phasellus ac leo eleifend, commodo tortor et, varius quam. Aliquam erat volutpat`

                            )->ele( `HBox`
                                )->a( n = `alignItems`     v = `Center`
                                )->a( n = `justifyContent` v = `Center`
                                )->a( n = `width`          v = `100%`

                                )->ele( `SegmentedButton`
                                    )->a( n = `width`           v = `320px`
                                    )->a( n = `selectedKey`     v = client->_bind( product_type )
                                    )->a( n = `selectionChange` v = client->_event( `SET_PRODUCT_TYPE` )

                                    )->ele( `items`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `icon` v = `sap-icon://iphone`
                                            )->a( n = `key`  v = `Mobile`
                                            )->a( n = `text` v = `Mobile`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `icon` v = `sap-icon://sys-monitor`
                                            )->a( n = `key`  v = `Desktop`
                                            )->a( n = `text` v = `Desktop`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `icon` v = `sap-icon://database`
                                            )->a( n = `key`  v = `Other`
                                            )->a( n = `text` v = `Other`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(

                        )->ele( `WizardStep`
                            )->a( n = `id`        v = `ProductInfoStep`
                            )->a( n = `validated` v = client->_bind( step2_validated )
                            )->a( n = `title`     v = `Product Information`
                            )->a( n = `activate`  v = client->_event( `ADDITIONAL_INFO` )

                            )->tag( `MessageStrip`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Validation in the wizard is controlled by calling the validateStep(Step) and invalidateStep(Step) methods `
                                )->a( n = `showIcon` v = `true`
                            )->tag( `Text`
                                )->a( n = `text` v = `Cras tellus leo, volutpat vitae ullamcorper eu, posuere malesuada nisl. Integer pellentesque leo sit amet dui vehicula, quis ullamcorper est pulvinar. ` &&
                                                    `Nam in libero sem. Suspendisse arcu metus, molestie a turpis a, molestie aliquet dui. Donec pulvinar, sapien et viverra imperdiet, orci erat porttitor nulla, ` &&
                                                    `eget commodo metus nibh nec ipsum. Aliquam lacinia euismod metus, sollicitudin pellentesque purus volutpat eget. Pellentesque egestas erat quis eros convallis mattis.`

                            )->ele( n = `SimpleForm` ns = `form`
                                )->a( n = `editable` v = `true`
                                )->a( n = `layout`   v = `ResponsiveGridLayout`

                                )->tag( `Label`
                                    )->a( n = `text`     v = `Name`
                                    )->a( n = `required` v = `true`
                                )->tag( `Input`
                                    )->a( n = `valueStateText` v = `Enter 6 symbols or more`
                                    )->a( n = `valueState`     v = client->_bind( product_name_state )
                                    )->a( n = `id`             v = `ProductName`
                                    )->a( n = `liveChange`     v = client->_event( `ADDITIONAL_INFO` )
                                    )->a( n = `placeholder`    v = `Enter name with length greater than 6`
                                    )->a( n = `value`          v = client->_bind( product_name )
                                )->tag( `Label`
                                    )->a( n = `text`     v = `Weight`
                                    )->a( n = `required` v = `true`
                                )->tag( `Input`
                                    )->a( n = `valueStateText` v = `Enter digits`
                                    )->a( n = `valueState`     v = client->_bind( product_weight_state )
                                    )->a( n = `id`             v = `ProductWeight`
                                    )->a( n = `liveChange`     v = client->_event( `ADDITIONAL_INFO` )
                                    )->a( n = `type`           v = `Number`
                                    )->a( n = `placeholder`    v = `Enter digits`
                                    )->a( n = `value`          v = client->_bind( product_weight )
                                )->tag( `Label`
                                    )->a( n = `text` v = `Manufacturer`

                                )->ele( `Select`
                                    )->a( n = `selectedKey` v = client->_bind( product_manufacturer )

                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Apple`
                                        )->a( n = `text` v = `Apple`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Microsoft`
                                        )->a( n = `text` v = `Microsoft`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Google`
                                        )->a( n = `text` v = `Google`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Sony`
                                        )->a( n = `text` v = `Sony`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Samsung`
                                        )->a( n = `text` v = `Samsung`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Logitech`
                                        )->a( n = `text` v = `Logitech`

                                )->end(
                                )->tag( `Label`
                                    )->a( n = `text` v = `Description`
                                )->tag( `TextArea`
                                    )->a( n = `value` v = client->_bind( product_description )
                                    )->a( n = `rows`  v = `8`

                            )->end(
                        )->end(

                        )->ele( `WizardStep`
                            )->a( n = `id`        v = `OptionalInfoStep`
                            )->a( n = `validated` v = `true`
                            )->a( n = `activate`  v = client->_event( `OPTIONAL_ACTIVATE` )
                            )->a( n = `title`     v = `Optional Information`

                            )->tag( `MessageStrip`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `You can validate steps by default with the validated='true' property of the step. The next button is always enabled.`
                                )->a( n = `showIcon` v = `true`
                            )->tag( `Text`
                                )->a( n = `text` v = `Integer pellentesque leo sit amet dui vehicula, quis ullamcorper est pulvinar. Nam in libero sem. Suspendisse arcu metus, molestie a turpis a, molestie aliquet dui. ` &&
                                                    `Donec pellentesque leo sit amet dui vehicula, quis ullamcorper est pulvinar. Nam in libero sem. Suspendisse arcu metus, molestie a turpis a, molestie aliquet dui. ` &&
                                                    `Donec pulvinar, sapien corper eu, posuere malesuada nisl.`

                            )->ele( n = `SimpleForm` ns = `form`
                                )->a( n = `editable` v = `true`
                                )->a( n = `layout`   v = `ResponsiveGridLayout`

                                )->tag( `Label`
                                    )->a( n = `text` v = `Cover photo`
                                )->tag( n = `FileUploader` ns = `u`
                                    )->a( n = `width`       v = `100%`
                                    )->a( n = `tooltip`     v = `Upload product cover photo to the local server`
                                    )->a( n = `style`       v = `Emphasized`
                                    )->a( n = `placeholder` v = `Choose a file for Upload...`
                                )->tag( `Label`
                                    )->a( n = `text` v = `Manufacturing date`
                                )->tag( `DatePicker`
                                    )->a( n = `id`            v = `DP3`
                                    )->a( n = `displayFormat` v = `short`
                                    )->a( n = `value`         v = client->_bind( manufacturing_date )
                                )->tag( `Label`
                                    )->a( n = `text` v = `Availability`

                                )->ele( `SegmentedButton`
                                    )->a( n = `selectedKey` v = client->_bind( availability_type )

                                    )->ele( `items`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `key`  v = `In store`
                                            )->a( n = `text` v = `In store`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `key`  v = `In depot`
                                            )->a( n = `text` v = `In depot`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `key`  v = `In repository`
                                            )->a( n = `text` v = `In repository`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `key`  v = `Out of stock`
                                            )->a( n = `text` v = `Out of stock`

                                    )->end(
                                )->end(
                                )->tag( `Label`
                                    )->a( n = `text` v = `Size`
                                )->tag( `Input`
                                    )->a( n = `value` v = client->_bind( size )

                                )->ele( `ComboBox`
                                    )->a( n = `maxWidth`    v = `100px`
                                    )->a( n = `selectedKey` v = client->_bind( measurement )

                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `X`
                                        )->a( n = `text` v = `X`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Y`
                                        )->a( n = `text` v = `Y`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Z`
                                        )->a( n = `text` v = `Z`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `WizardStep`
                            )->a( n = `id`        v = `PricingStep`
                            )->a( n = `validated` v = `true`
                            )->a( n = `title`     v = `Pricing`

                            )->tag( `MessageStrip`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `You can use the wizard previousStep() and nextStep() methods to navigate from step to step without validation. ` &&
                                                        `Also you can use the GoToStep(step) method to scroll programmatically to previously visited steps.`
                                )->a( n = `showIcon` v = `true`

                            )->ele( n = `SimpleForm` ns = `form`
                                )->a( n = `editable` v = `true`
                                )->a( n = `layout`   v = `ResponsiveGridLayout`

                                )->tag( `Label`
                                    )->a( n = `text` v = `Price`
                                )->tag( `Input`
                                    )->a( n = `value` v = client->_bind( product_price )
                                )->tag( `Label`
                                    )->a( n = `text` v = `Discount group`

                                )->ele( `ComboBox`
                                    )->a( n = `selectedKey` v = client->_bind( discount_group )

                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Kids`
                                        )->a( n = `text` v = `Kids`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Teens`
                                        )->a( n = `text` v = `Teens`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Adults`
                                        )->a( n = `text` v = `Adults`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Elderly`
                                        )->a( n = `text` v = `Elderly`

                                )->end(
                                )->tag( `Label`
                                    )->a( n = `text` v = ` VAT is included`
                                )->tag( `CheckBox`
                                    )->a( n = `selected` v = client->_bind( product_vat )

                            )->end(
                        )->end(

                        )->ele( `WizardStep`
                            )->a( n = `id`        v = `ReviewPage`
                            )->a( n = `validated` v = `true`
                            )->a( n = `title`     v = `Review page`

                            )->ele( n = `SimpleForm` ns = `form`
                                )->a( n = `title`    v = `1. Product Type`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ResponsiveGridLayout`

                                )->ele( n = `content` ns = `form`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Type`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `ProductTypeChosen`
                                        )->a( n = `text` v = client->_bind( product_type )
                                    )->tag( `Link`
                                        )->a( n = `press` v = client->_event( `EDIT_STEP_1` )
                                        )->a( n = `text`  v = `Edit`

                                )->end(
                            )->end(
                            )->ele( n = `SimpleForm` ns = `form`
                                )->a( n = `title`    v = `2. Product Information`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ResponsiveGridLayout`

                                )->ele( n = `content` ns = `form`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Name`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `ProductNameChosen`
                                        )->a( n = `text` v = client->_bind( product_name )
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Weight`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `ProductWeightChosen`
                                        )->a( n = `text` v = client->_bind( product_weight )
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Manufacturer`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `ProductManufacturerChosen`
                                        )->a( n = `text` v = client->_bind( product_manufacturer )
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Description`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `ProductDescriptionChosen`
                                        )->a( n = `text` v = client->_bind( product_description )
                                    )->tag( `Link`
                                        )->a( n = `press` v = client->_event( `EDIT_STEP_2` )
                                        )->a( n = `text`  v = `Edit`

                                )->end(
                            )->end(
                            )->ele( n = `SimpleForm` ns = `form`
                                )->a( n = `title`    v = `3. Optional Information`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ResponsiveGridLayout`

                                )->ele( n = `content` ns = `form`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Some text`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. `
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Manufacturing Date`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `ManufacturingDate`
                                        )->a( n = `text` v = client->_bind( manufacturing_date )
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Availability`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `AvailabilityChosen`
                                        )->a( n = `text` v = client->_bind( availability_type )
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Size`

                                    )->ele( `HBox`
                                        )->tag( `Text`
                                            )->a( n = `id`   v = `Size`
                                            )->a( n = `text` v = client->_bind( size )
                                        )->tag( `Text`
                                            )->a( n = `id`    v = `Size2`
                                            )->a( n = `class` v = `sapUiTinyMarginBegin`
                                            )->a( n = `text`  v = client->_bind( measurement )

                                    )->end(
                                    )->tag( `Link`
                                        )->a( n = `press` v = client->_event( `EDIT_STEP_3` )
                                        )->a( n = `text`  v = `Edit`

                                )->end(
                            )->end(
                            )->ele( n = `SimpleForm` ns = `form`
                                )->a( n = `title`    v = `4. Pricing`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ResponsiveGridLayout`

                                )->ele( n = `content` ns = `form`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Price`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `ProductPriceChosen`
                                        )->a( n = `text` v = client->_bind( product_price )
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Discount Group`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `DiscountGroupChosen`
                                        )->a( n = `text` v = client->_bind( discount_group )
                                    )->tag( `Label`
                                        )->a( n = `text` v = `VAT Included`
                                    )->tag( `Text`
                                        )->a( n = `id`   v = `ProductVATChosen`
                                        )->a( n = `text` v = client->_bind( product_vat )
                                    )->tag( `Link`
                                        )->a( n = `press` v = client->_event( `EDIT_STEP_4` )
                                        )->a( n = `text`  v = `Edit`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( n = `footer` ns = `f`
                    )->ele( `OverflowToolbar`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `text`    v = `Previous Step`
                            )->a( n = `visible` v = v_back
                            )->a( n = `press`   v = client->_event( `DIALOG_BACK` )
                        )->tag( `Button`
                            )->a( n = `text`    v = `Next Step`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `enabled` v = client->_bind( next_enabled )
                            )->a( n = `visible` v = v_next
                            )->a( n = `press`   v = client->_event( `DIALOG_NEXT` )
                        )->tag( `Button`
                            )->a( n = `text`    v = `Review`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `visible` v = v_rev
                            )->a( n = `press`   v = client->_event( `DIALOG_NEXT` )
                        )->tag( `Button`
                            )->a( n = `text`    v = `Finish`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `visible` v = v_fin
                            )->a( n = `press`   v = client->_event( `WIZARD_SUBMIT` )
                        )->tag( `Button`
                            )->a( n = `text`  v = `Cancel`
                            )->a( n = `type`  v = `Transparent`
                            )->a( n = `press` v = client->_event( `WIZARD_CANCEL` )

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `OPEN_DIALOG`.
        popup_wizard_display( ).

      WHEN `NAVIGATION_CHANGE`.
        " handleNavigationChange: the selected step becomes the new index
        DATA(step_title) = client->get_event_arg( ).
        CASE step_title.
          WHEN `Product Type`.
            step_index = 0.
          WHEN `Product Information`.
            step_index = 1.
          WHEN `Optional Information`.
            step_index = 2.
          WHEN `Pricing`.
            step_index = 3.
          WHEN `Review page`.
            step_index = 4.
        ENDCASE.

      WHEN `SET_PRODUCT_TYPE`.
        " setProductTypeFromSegmented also validates step 1, which is already
        " validated="true" in the view

      WHEN `ADDITIONAL_INFO`.
        info_validate( ).

      WHEN `OPTIONAL_ACTIVATE`.
        client->message_toast_display( `This event is fired on activate of Step3.` ).

      WHEN `DIALOG_NEXT`.
        step_goto( step_index + 1 ).

      WHEN `DIALOG_BACK`.
        step_goto( step_index - 1 ).

      WHEN `EDIT_STEP_1`.
        step_goto( 0 ).

      WHEN `EDIT_STEP_2`.
        step_goto( 1 ).

      WHEN `EDIT_STEP_3`.
        step_goto( 2 ).

      WHEN `EDIT_STEP_4`.
        step_goto( 3 ).

      WHEN `WIZARD_CANCEL`.
        client->message_box_display( text    = `Are you sure you want to cancel your report?`
                                     type    = `warning`
                                     actions = VALUE #( ( `YES` ) ( `NO` ) )
                                     onclose = `WIZARD_CLOSED` ).

      WHEN `WIZARD_SUBMIT`.
        client->message_box_display( text    = `Are you sure you want to submit your report?`
                                     type    = `confirm`
                                     actions = VALUE #( ( `YES` ) ( `NO` ) )
                                     onclose = `WIZARD_CLOSED` ).

      WHEN `WIZARD_CLOSED`.
        " _handleMessageBoxOpen: YES discards the progress, closes the dialog and
        " resets the model to the initial oData
        IF client->get_event_arg( ) = `YES`.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `CreateProductWizard` ) ( `discardProgress` ) ( `ProductTypeStep` ) ) ).
          model_init( ).
          client->popup_destroy( ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD step_goto.

    " goToStep( steps[ index ], true ) - Wizard.currentStep is an ASSOCIATION and
    " cannot be bound, so the navigation goes through the control_by_id call the
    " framework whitelists for exactly this (app 101 idiom)
    DATA(steps) = VALUE string_table( ( `ProductTypeStep` ) ( `ProductInfoStep` )
                                      ( `OptionalInfoStep` ) ( `PricingStep` ) ( `ReviewPage` ) ).
    IF index >= 0 AND index < lines( steps ).
      step_index   = index.
      current_step = steps[ index + 1 ].
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `CreateProductWizard` ) ( `goToStep` ) ( current_step ) ( `true` ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD info_validate.

    " additionalInfoValidation: a name of at least six characters and a numeric
    " weight; both drive their value state, the step's validated flag and the
    " Next button
    DATA(name_ok)   = xsdbool( strlen( product_name ) >= 6 ).
    DATA(weight_ok) = xsdbool( product_weight IS NOT INITIAL AND product_weight CO `0123456789.` ).

    product_name_state   = COND #( WHEN name_ok   = abap_true THEN `None` ELSE `Error` ).
    product_weight_state = COND #( WHEN weight_ok = abap_true THEN `None` ELSE `Error` ).

    step2_validated = xsdbool( name_ok = abap_true AND weight_ok = abap_true ).
    next_enabled    = step2_validated.

    IF step2_validated = abap_false AND step_index > 1.
      " setCurrentStep( ProductInfoStep ) - the wizard stays on the invalid step
      step_goto( 1 ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the controller's oData seed
    product_name_state   = `Error`.
    product_weight_state = `Error`.
    product_type         = `Mobile`.
    availability_type    = `In store`.
    product_vat          = abap_false.
    measurement          = ``.
    product_manufacturer = `N/A`.
    product_description  = `N/A`.
    size                 = `N/A`.
    product_price        = `N/A`.
    manufacturing_date   = `N/A`.
    discount_group       = ``.
    product_name         = ``.
    product_weight       = ``.
    step2_validated      = abap_false.
    next_enabled         = abap_true.
    step_index           = 0.
    current_step         = `ProductTypeStep`.

  ENDMETHOD.

ENDCLASS.
