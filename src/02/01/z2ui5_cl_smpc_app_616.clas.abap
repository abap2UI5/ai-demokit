" @keywords combobox combo box sap.m comboboxvaluestate formattedtext link
" @summary The combo box can show different value states.
CLASS z2ui5_cl_smpc_app_616 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_country,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_country.
    TYPES ty_t_country TYPE STANDARD TABLE OF ty_s_country WITH EMPTY KEY.

    DATA t_countries TYPE ty_t_country.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_616 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(layout) = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`
            )->ele( `content`
                )->ele( n = `VerticalLayout` ns = `l` ).

    layout->tag( `Label`
        )->a( n = `text`     v = `ComboBox in a Success state`
        )->a( n = `labelFor` v = `idComboBoxSuccess`
        " the items binding is declared SUSPENDED and resumed by loadItems; the
        " backend already holds the rows, so the port binds them outright
        )->ele( `ComboBox`
            )->a( n = `class`      v = `sapUiSmallMarginBottom`
            )->a( n = `id`         v = `idComboBoxSuccess`
            )->a( n = `valueState` v = `Success`
            )->a( n = `items`      v = client->_bind( t_countries )
            )->ele( `items`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}`
            )->end(
        )->end( ).

    layout->tag( `Label`
        )->a( n = `text`     v = `ComboBox in an Information state`
        )->a( n = `labelFor` v = `idComboBoxInformation`
        )->ele( `ComboBox`
            )->a( n = `class`      v = `sapUiSmallMarginBottom`
            )->a( n = `id`         v = `idComboBoxInformation`
            )->a( n = `valueState` v = `Information`
            )->a( n = `items`      v = client->_bind( t_countries )
            )->ele( `items`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}`
            )->end(
        )->end( ).

    layout->tag( `Label`
        )->a( n = `text`     v = `Information state message with a link.`
        )->a( n = `labelFor` v = `idComboBoxInformationWithLink`
        )->ele( `ComboBox`
            )->a( n = `class`          v = `sapUiSmallMarginBottom`
            )->a( n = `id`             v = `idComboBoxInformationWithLink`
            )->a( n = `valueState`     v = `Information`
            )->a( n = `valueStateText` v = `Warning message. Extra long text used as a warning message. Extra long text used as a warning message - 2. Extra long text used as a warning message - 3.`
            )->a( n = `items`          v = client->_bind( t_countries )
            )->ele( `items`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}`
            )->end(
            )->ele( `formattedValueStateText`
                )->ele( `FormattedText`
                    )->a( n = `htmlText` v = `Warning message. Long text used as a warning message with a %%0.`
                    )->ele( `controls`
                        )->tag( `Link`
                            )->a( n = `text`  v = `link`
                            )->a( n = `href`  v = ``
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Link in value state pressed` ) ) )
                    )->end(
                )->end(
            )->end(
        )->end( ).

    layout->tag( `Label`
        )->a( n = `text`     v = `ComboBox in a Warning state`
        )->a( n = `labelFor` v = `idComboBoxWarning`
        )->ele( `ComboBox`
            )->a( n = `class`          v = `sapUiSmallMarginBottom`
            )->a( n = `id`             v = `idComboBoxWarning`
            )->a( n = `valueState`     v = `Warning`
            )->a( n = `valueStateText` v = `Warning message. Extra long text used as a warning message. Extra long text used as a warning message - 2. Extra long text used as a warning message - 3.`
            )->a( n = `items`          v = client->_bind( t_countries )
            )->ele( `items`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}`
            )->end(
        )->end( ).

    layout->tag( `Label`
        )->a( n = `text`     v = `Warning state with multiple links.`
        )->a( n = `labelFor` v = `idComboBoxWarningWithLinks`
        )->ele( `ComboBox`
            )->a( n = `class`      v = `sapUiSmallMarginBottom`
            )->a( n = `id`         v = `idComboBoxWarningWithLinks`
            )->a( n = `valueState` v = `Warning`
            )->a( n = `items`      v = client->_bind( t_countries )
            )->ele( `items`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}`
            )->end(
            )->ele( `formattedValueStateText`
                )->ele( `FormattedText`
                    )->a( n = `htmlText` v = `Error message. Long text used as an error message with %%0 %%1.`
                    )->ele( `controls`
                        )->tag( `Link`
                            )->a( n = `text`  v = `multiple`
                            )->a( n = `href`  v = ``
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Link in value state pressed` ) ) )
                        )->tag( `Link`
                            )->a( n = `text`  v = `links`
                            )->a( n = `href`  v = ``
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Link in value state pressed` ) ) )
                    )->end(
                )->end(
            )->end(
        )->end( ).

    layout->tag( `Label`
        )->a( n = `text`     v = `ComboBox in an Error state`
        )->a( n = `labelFor` v = `idComboBoxError`
        )->ele( `ComboBox`
            )->a( n = `class`      v = `sapUiSmallMarginBottom`
            )->a( n = `id`         v = `idComboBoxError`
            )->a( n = `valueState` v = `Error`
            )->a( n = `items`      v = client->_bind( t_countries )
            )->ele( `items`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}`
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/demo/mock/countriesExtendedCollection.json /CountriesCollection,
    " seeded verbatim; the binding's sorter on text is applied to the data the
    " backend sends (app 298 idiom)
    t_countries = VALUE #(
      ( key = `DZ` text = `Algeria` )
      ( key = `AR` text = `Argentina` )
      ( key = `AU` text = `Australia` )
      ( key = `AT` text = `Austria` )
      ( key = `BH` text = `Bahrain` )
      ( key = `BE` text = `Belgium` )
      ( key = `BA` text = `Bosnia and Herzegovina` )
      ( key = `BR` text = `Brazil` )
      ( key = `BG` text = `Bulgaria` )
      ( key = `CA` text = `Canada` )
      ( key = `CL` text = `Chile` )
      ( key = `CO` text = `Colombia` )
      ( key = `HR` text = `Croatia` )
      ( key = `CU` text = `Cuba` )
      ( key = `CZ` text = `Czech Republic` )
      ( key = `DK` text = `Denmark` )
      ( key = `EG` text = `Egypt` )
      ( key = `EE` text = `Estonia` )
      ( key = `FI` text = `Finland` )
      ( key = `FR` text = `France` )
      ( key = `GER` text = `Germany` )
      ( key = `GH` text = `Ghana` )
      ( key = `GR` text = `Greece` )
      ( key = `HU` text = `Hungary` )
      ( key = `IN` text = `India` )
      ( key = `ID` text = `Indonesia` )
      ( key = `IE` text = `Ireland` )
      ( key = `IL` text = `Israel` )
      ( key = `IT` text = `Italy` )
      ( key = `JP` text = `Japan` )
      ( key = `JO` text = `Jordan` )
      ( key = `KE` text = `Kenya` )
      ( key = `KW` text = `Kuwait` )
      ( key = `LV` text = `Latvia` )
      ( key = `LT` text = `Lithuania` )
      ( key = `MK` text = `Macedonia` )
      ( key = `MY` text = `Malaysia` )
      ( key = `MX` text = `Mexico` )
      ( key = `ME` text = `Montenegro` )
      ( key = `MA` text = `Morocco` )
      ( key = `NL` text = `Netherlands` )
      ( key = `NZ` text = `New Zealand` )
      ( key = `NG` text = `Nigeria` )
      ( key = `NO` text = `Norway` )
      ( key = `OM` text = `Oman` )
      ( key = `PE` text = `Peru` )
      ( key = `PH` text = `Philippines` )
      ( key = `PL` text = `Poland` )
      ( key = `PT` text = `Portugal` )
      ( key = `QA` text = `Qatar` )
      ( key = `RO` text = `Romania` )
      ( key = `RU` text = `Russia` )
      ( key = `SA` text = `Saudi Arabia` )
      ( key = `SN` text = `Senegal` )
      ( key = `RS` text = `Serbia` )
      ( key = `SG` text = `Singapore` )
      ( key = `SK` text = `Slovakia` )
      ( key = `SI` text = `Slovenia` )
      ( key = `ZA` text = `South Africa` )
      ( key = `KR` text = `South Korea` )
      ( key = `ES` text = `Spain` )
      ( key = `SE` text = `Sweden` )
      ( key = `CH` text = `Switzerland` )
      ( key = `TN` text = `Tunisia` )
      ( key = `TR` text = `Turkey` )
      ( key = `UG` text = `Uganda` )
      ( key = `UA` text = `Ukraine` )
      ( key = `AE` text = `United Arab Emirates` )
      ( key = `GB` text = `United Kingdom` )
      ( key = `YE` text = `Yemen` )
    ).

    SORT t_countries BY text AS TEXT ASCENDING.

  ENDMETHOD.

ENDCLASS.
