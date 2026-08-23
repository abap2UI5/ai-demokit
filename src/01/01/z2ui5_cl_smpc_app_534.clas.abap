" @keywords wizard sap.m wizardcurrentstep navcontainer bar segmentedbutton segmentedbuttonitem label select item wizardstep messagestrip
" @summary Demonstrates the usage of the setCurrentStep association, which controlls the current step of the wizard.
CLASS z2ui5_cl_smpc_app_534 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selectedshowcase          TYPE string.
    DATA selectedbackgrounddesign  TYPE string.
    DATA linearwizardselectedstep  TYPE string.
    DATA branchingselectedstep     TYPE string.

    DATA product_name         TYPE string.
    DATA product_name_state   TYPE string.
    DATA product_weight       TYPE string.
    DATA product_weight_state TYPE string.
    DATA product_manufacturer TYPE string.
    DATA product_description  TYPE string.
    DATA product_price        TYPE string.
    DATA product_vat          TYPE abap_bool.
    DATA step2_validated      TYPE abap_bool.
    DATA path_index           TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS path_apply.
    METHODS info_validate.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_534 IMPLEMENTATION.

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
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `NavContainer`
            )->a( n = `id` v = `wizardNavContainer`

            )->ele( `pages`
                )->ele( `Page`
                    )->a( n = `id`         v = `wizardContentPage`
                    )->a( n = `showHeader` v = `true`

                    )->ele( `customHeader`
                        )->ele( `Bar`
                            )->ele( `contentRight`
                                )->ele( `SegmentedButton`
                                    )->a( n = `selectedKey` v = client->_bind( selectedshowcase )

                                    )->ele( `items`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `text` v = `Linear case`
                                            )->a( n = `key`  v = `linear`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `text`  v = `Branching case`
                                            )->a( n = `key`   v = `branching`
                                            )->a( n = `width` v = `150px`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(

                    )->ele( `subHeader`
                        )->ele( `Bar`
                            )->ele( `contentRight`
                                )->tag( `Label`
                                    )->a( n = `text` v = `Set current step: `

                                )->ele( `Select`
                                    )->a( n = `change`      v = client->_event( val   = `CURRENT_STEP_LINEAR`
                                                                                t_arg = VALUE #( ( `${$parameters>/selectedItem}.getKey()` ) ) )
                                    )->a( n = `selectedKey` v = client->_bind( linearwizardselectedstep )
                                    )->a( n = `visible`     v = |\{= ${ client->_bind( selectedshowcase ) } === 'linear'\}|

                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `ProductTypeStep`
                                        )->a( n = `key`  v = `ProductTypeStep`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `ProductInfoStep`
                                        )->a( n = `key`  v = `ProductInfoStep`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `OptionalInfoStep`
                                        )->a( n = `key`  v = `OptionalInfoStep`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `PricingStep`
                                        )->a( n = `key`  v = `PricingStep`

                                )->end(

                                )->ele( `Select`
                                    )->a( n = `id`          v = `selectBranchingCurrentStep`
                                    )->a( n = `change`      v = client->_event( val   = `CURRENT_STEP_BRANCHING`
                                                                                t_arg = VALUE #( ( `${$parameters>/selectedItem}.getKey()` ) ) )
                                    )->a( n = `selectedKey` v = client->_bind( branchingselectedstep )
                                    )->a( n = `visible`     v = |\{= ${ client->_bind( selectedshowcase ) } === 'branching'\}|

                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `A`
                                        )->a( n = `key`  v = `A`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `B1`
                                        )->a( n = `key`  v = `B1`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `B2`
                                        )->a( n = `key`  v = `B2`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `C`
                                        )->a( n = `key`  v = `C`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `D`
                                        )->a( n = `key`  v = `D`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `E`
                                        )->a( n = `key`  v = `E`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `F1`
                                        )->a( n = `key`  v = `F1`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `F2`
                                        )->a( n = `key`  v = `F2`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `G`
                                        )->a( n = `key`  v = `G`

                                )->end(
                            )->end(
                        )->end(
                    )->end(

                    )->ele( `content`

                        " the two nested XMLViews are inlined here (see sidecar):
                        " the Linear wizard first, the Branching wizard second,
                        " each with the visible expression the original gives its
                        " mvc:XMLView
                        )->ele( `Wizard`
                            )->a( n = `id`               v = `CreateProductWizard`
                            )->a( n = `finishButtonText` v = `Finish`
                            )->a( n = `currentStep`      v = `PricingStep`
                            )->a( n = `visible`          v = |\{= ${ client->_bind( selectedshowcase ) } === 'linear' \}|
                            )->a( n = `class`            v = `sapUiResponsivePadding--header sapUiResponsivePadding--content`

                            )->ele( `WizardStep`
                                )->a( n = `id`       v = `ProductTypeStep`
                                )->a( n = `title`    v = `Product Type`
                                )->a( n = `activate` v = client->_event( val   = `ACTIVATE_LINEAR`
                                                                         t_arg = VALUE #( ( `ProductTypeStep` ) ) )

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
                                        )->a( n = `width` v = `320px`

                                        )->ele( `items`
                                            )->tag( `SegmentedButtonItem`
                                                )->a( n = `icon` v = `sap-icon://iphone`
                                                )->a( n = `text` v = `Mobile`
                                            )->tag( `SegmentedButtonItem`
                                                )->a( n = `icon` v = `sap-icon://sys-monitor`
                                                )->a( n = `text` v = `Desktop`
                                            )->tag( `SegmentedButtonItem`
                                                )->a( n = `icon` v = `sap-icon://database`
                                                )->a( n = `text` v = `Other`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(

                            )->ele( `WizardStep`
                                )->a( n = `id`        v = `ProductInfoStep`
                                )->a( n = `title`     v = `Product Information`
                                )->a( n = `validated` v = client->_bind( step2_validated )
                                )->a( n = `activate`  v = client->_event( val   = `ACTIVATE_LINEAR`
                                                                          t_arg = VALUE #( ( `ProductInfoStep` ) ) )

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
                                        )->a( n = `change`         v = client->_event( `VALIDATE_INFO` )
                                        )->a( n = `placeholder`    v = `Enter name with length greater than 6`
                                        )->a( n = `value`          v = client->_bind( product_name )
                                    )->tag( `Label`
                                        )->a( n = `text`     v = `Weight`
                                        )->a( n = `required` v = `true`
                                    )->tag( `Input`
                                        )->a( n = `valueStateText` v = `Enter digits`
                                        )->a( n = `valueState`     v = client->_bind( product_weight_state )
                                        )->a( n = `id`             v = `ProductWeight`
                                        )->a( n = `change`         v = client->_event( `VALIDATE_INFO` )
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
                                )->a( n = `id`       v = `OptionalInfoStep`
                                )->a( n = `optional` v = `true`
                                )->a( n = `title`    v = `Additional Information`
                                )->a( n = `activate` v = client->_event( val   = `ACTIVATE_LINEAR`
                                                                         t_arg = VALUE #( ( `OptionalInfoStep` ) ) )

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
                                        )->a( n = `width`       v = `400px`
                                        )->a( n = `tooltip`     v = `Upload product cover photo to the local server`
                                        )->a( n = `style`       v = `Emphasized`
                                        )->a( n = `placeholder` v = `Choose a file for Upload...`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Manufacturing date`
                                    )->tag( `DatePicker`
                                        )->a( n = `id`            v = `DP3`
                                        )->a( n = `displayFormat` v = `short`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Availability`

                                    )->ele( `SegmentedButton`
                                        )->a( n = `selectedItem` v = `inStock`

                                        )->ele( `items`
                                            )->tag( `SegmentedButtonItem`
                                                )->a( n = `text` v = `In store`
                                                )->a( n = `id`   v = `inStock`
                                            )->tag( `SegmentedButtonItem`
                                                )->a( n = `text` v = `In depot`
                                            )->tag( `SegmentedButtonItem`
                                                )->a( n = `text` v = `In repository`
                                            )->tag( `SegmentedButtonItem`
                                                )->a( n = `text` v = `Out of stock`

                                        )->end(
                                    )->end(
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Size`
                                    )->tag( `Input`

                                    )->ele( `ComboBox`
                                        )->a( n = `maxWidth` v = `100px`

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
                                )->a( n = `id`       v = `PricingStep`
                                )->a( n = `title`    v = `Pricing`
                                )->a( n = `activate` v = client->_event( val   = `ACTIVATE_LINEAR`
                                                                         t_arg = VALUE #( ( `PricingStep` ) ) )

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

                                    )->ele( `MultiComboBox`

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
                        )->end(

                        )->ele( `Wizard`
                            )->a( n = `id`              v = `BranchingWizard`
                            )->a( n = `enableBranching` v = `true`
                            )->a( n = `visible`         v = |\{= ${ client->_bind( selectedshowcase ) } === 'branching' \}|
                            )->a( n = `class`           v = `sapUiResponsivePadding--header sapUiResponsivePadding--content`

                            )->ele( `WizardStep`
                                )->a( n = `validated`       v = `false`
                                )->a( n = `id`              v = `A`
                                )->a( n = `title`           v = `A`
                                )->a( n = `subsequentSteps` v = `B1, B2`

                                )->ele( `RadioButtonGroup`
                                    )->a( n = `id`     v = `PathSelection`
                                    )->a( n = `select` v = client->_event( val   = `APPLY_PATH`
                                                                           t_arg = VALUE #( ( `${$parameters>/selectedIndex}` ) ) )

                                    )->ele( `buttons`
                                        )->tag( `RadioButton`
                                            )->a( n = `text` v = `A->B1->C->D->E->F1->F2->G`
                                        )->tag( `RadioButton`
                                            )->a( n = `text` v = `A->B2->C->D->E->F1->G`
                                        )->tag( `RadioButton`
                                            )->a( n = `text` v = `A->B1->B2->C->D->E`

                                    )->end(
                                )->end(
                            )->end(

                            )->tag( `WizardStep`
                                )->a( n = `validated` v = `false`
                                )->a( n = `id`        v = `B1`
                                )->a( n = `title`     v = `B1`
                                )->a( n = `nextStep`  v = `C`
                            )->tag( `WizardStep`
                                )->a( n = `validated` v = `false`
                                )->a( n = `id`        v = `B2`
                                )->a( n = `title`     v = `B2`
                                )->a( n = `nextStep`  v = `C`
                            )->tag( `WizardStep`
                                )->a( n = `validated` v = `false`
                                )->a( n = `id`        v = `C`
                                )->a( n = `title`     v = `C`
                                )->a( n = `nextStep`  v = `D`
                            )->tag( `WizardStep`
                                )->a( n = `validated` v = `false`
                                )->a( n = `id`        v = `D`
                                )->a( n = `title`     v = `D`
                                )->a( n = `nextStep`  v = `E`
                            )->tag( `WizardStep`
                                )->a( n = `validated`       v = `false`
                                )->a( n = `id`              v = `E`
                                )->a( n = `title`           v = `E`
                                )->a( n = `subsequentSteps` v = `F1, F2`
                            )->tag( `WizardStep`
                                )->a( n = `validated` v = `false`
                                )->a( n = `id`        v = `F1`
                                )->a( n = `title`     v = `F1`
                                )->a( n = `nextStep`  v = `G`
                            )->tag( `WizardStep`
                                )->a( n = `validated` v = `false`
                                )->a( n = `id`        v = `F2`
                                )->a( n = `title`     v = `F2`
                                )->a( n = `nextStep`  v = `G`
                            )->tag( `WizardStep`
                                )->a( n = `validated` v = `false`
                                )->a( n = `id`        v = `G`
                                )->a( n = `title`     v = `G`

                        )->end(
                    )->end(

                    )->ele( `footer`
                        )->ele( `Bar`
                            )->ele( `contentRight`
                                )->tag( `Label`
                                    )->a( n = `text` v = `Set background design: `

                                )->ele( `Select`
                                    )->a( n = `change`      v = client->_event( val   = `BACKGROUND_DESIGN`
                                                                                t_arg = VALUE #( ( `${$parameters>/selectedItem}.getKey()` ) ) )
                                    )->a( n = `selectedKey` v = client->_bind( selectedbackgrounddesign )

                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `Standard`
                                        )->a( n = `key`  v = `Standard`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `Solid`
                                        )->a( n = `key`  v = `Solid`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `List`
                                        )->a( n = `key`  v = `List`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `text` v = `Transparent`
                                        )->a( n = `key`  v = `Transparent` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `CURRENT_STEP_LINEAR`.
        " onCurrentStepChangeLinear: setCurrentStep on the linear wizard
        linearwizardselectedstep = client->get_event_arg( ).
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `CreateProductWizard` ) ( `goToStep` ) ( linearwizardselectedstep ) ) ).

      WHEN `CURRENT_STEP_BRANCHING`.
        " onCurrentStepChangeBranching: setCurrentStep on the branching wizard
        branchingselectedstep = client->get_event_arg( ).
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `BranchingWizard` ) ( `goToStep` ) ( branchingselectedstep ) ) ).

      WHEN `BACKGROUND_DESIGN`.
        " onBackgroundDesignChange sets the design on BOTH wizards
        selectedbackgrounddesign = client->get_event_arg( ).

      WHEN `ACTIVATE_LINEAR`.
        " onActivate syncs the Select with the step that just activated and
        " revalidates the product-information step
        linearwizardselectedstep = client->get_event_arg( ).
        IF linearwizardselectedstep = `ProductInfoStep`.
          info_validate( ).
        ENDIF.

      WHEN `VALIDATE_INFO`.
        info_validate( ).

      WHEN `APPLY_PATH`.
        " discardAndApplyPath discards the progress, resets the Select and
        " rewires the path the picked radio button spells out
        path_index = client->get_event_arg( ).
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `BranchingWizard` ) ( `discardProgress` ) ( `A` ) ) ).
        branchingselectedstep = `A`.
        path_apply( ).

    ENDCASE.

  ENDMETHOD.


  METHOD path_apply.

    " applyPath reads the picked radio button's TEXT and setNextStep's its way
    " down the arrow-separated path, clearing the last step's nextStep
    DATA(paths) = VALUE string_table( ( `A->B1->C->D->E->F1->F2->G` )
                                      ( `A->B2->C->D->E->F1->G` )
                                      ( `A->B1->B2->C->D->E` ) ).
    IF path_index < 0 OR path_index >= lines( paths ).
      RETURN.
    ENDIF.

    SPLIT paths[ path_index + 1 ] AT `->` INTO TABLE DATA(steps).
    LOOP AT steps INTO DATA(step).
      DATA(idx) = sy-tabix.
      IF idx < lines( steps ).
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( step ) ( `setNextStep` ) ( steps[ idx + 1 ] ) ) ).
      ELSE.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( step ) ( `setNextStep` ) ( `` ) ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD info_validate.

    " validateProdInfoStep: a name of at least six characters and a numeric weight
    DATA(name_ok)   = xsdbool( strlen( product_name ) >= 6 ).
    DATA(weight_ok) = xsdbool( product_weight IS NOT INITIAL AND product_weight CO `0123456789.` ).

    product_name_state   = COND #( WHEN name_ok   = abap_true THEN `None` ELSE `Error` ).
    product_weight_state = COND #( WHEN weight_ok = abap_true THEN `None` ELSE `Error` ).
    step2_validated      = xsdbool( name_ok = abap_true AND weight_ok = abap_true ).

  ENDMETHOD.


  METHOD model_init.

    " the controller's JSONModel seed
    selectedbackgrounddesign = `Standard`.
    selectedshowcase         = `linear`.
    linearwizardselectedstep = `PricingStep`.
    branchingselectedstep    = `A`.
    path_index               = 0.
    product_name_state       = `None`.
    product_weight_state     = `None`.
    " the Linear view declares no validated attribute, so every step starts
    " VALIDATED - which is what lets currentStep="PricingStep" hold on startup;
    " validateProdInfoStep is the only thing that ever clears it
    step2_validated          = abap_true.

  ENDMETHOD.

ENDCLASS.
