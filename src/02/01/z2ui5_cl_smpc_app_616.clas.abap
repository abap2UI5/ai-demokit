" @keywords combobox combo box sap.m comboboxvaluestate verticallayout listitem formattedtext link
" @summary The combo box can show different value states.
CLASS z2ui5_cl_smpc_app_616 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_country,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_country.
    TYPES ty_t_country TYPE STANDARD TABLE OF ty_s_country WITH DEFAULT KEY.

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
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA layout TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    layout = view->ele( n = `View` ns = `mvc`
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

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Link in value state pressed` INTO TABLE temp1.
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
                                                                             t_arg = temp1 )
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

    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Link in value state pressed` INTO TABLE temp3.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Link in value state pressed` INTO TABLE temp2.
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
                                                                             t_arg = temp3 )
                        )->tag( `Link`
                            )->a( n = `text`  v = `links`
                            )->a( n = `href`  v = ``
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = temp2 )
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
    DATA temp5 TYPE z2ui5_cl_smpc_app_616=>ty_t_country.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp5.
    
    temp6-key = `DZ`.
    temp6-text = `Algeria`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `AR`.
    temp6-text = `Argentina`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `AU`.
    temp6-text = `Australia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `AT`.
    temp6-text = `Austria`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `BH`.
    temp6-text = `Bahrain`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `BE`.
    temp6-text = `Belgium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `BA`.
    temp6-text = `Bosnia and Herzegovina`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `BR`.
    temp6-text = `Brazil`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `BG`.
    temp6-text = `Bulgaria`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `CA`.
    temp6-text = `Canada`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `CL`.
    temp6-text = `Chile`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `CO`.
    temp6-text = `Colombia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `HR`.
    temp6-text = `Croatia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `CU`.
    temp6-text = `Cuba`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `CZ`.
    temp6-text = `Czech Republic`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `DK`.
    temp6-text = `Denmark`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `EG`.
    temp6-text = `Egypt`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `EE`.
    temp6-text = `Estonia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `FI`.
    temp6-text = `Finland`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `FR`.
    temp6-text = `France`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `GER`.
    temp6-text = `Germany`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `GH`.
    temp6-text = `Ghana`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `GR`.
    temp6-text = `Greece`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `HU`.
    temp6-text = `Hungary`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `IN`.
    temp6-text = `India`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `ID`.
    temp6-text = `Indonesia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `IE`.
    temp6-text = `Ireland`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `IL`.
    temp6-text = `Israel`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `IT`.
    temp6-text = `Italy`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `JP`.
    temp6-text = `Japan`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `JO`.
    temp6-text = `Jordan`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `KE`.
    temp6-text = `Kenya`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `KW`.
    temp6-text = `Kuwait`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `LV`.
    temp6-text = `Latvia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `LT`.
    temp6-text = `Lithuania`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `MK`.
    temp6-text = `Macedonia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `MY`.
    temp6-text = `Malaysia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `MX`.
    temp6-text = `Mexico`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `ME`.
    temp6-text = `Montenegro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `MA`.
    temp6-text = `Morocco`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `NL`.
    temp6-text = `Netherlands`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `NZ`.
    temp6-text = `New Zealand`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `NG`.
    temp6-text = `Nigeria`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `NO`.
    temp6-text = `Norway`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `OM`.
    temp6-text = `Oman`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `PE`.
    temp6-text = `Peru`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `PH`.
    temp6-text = `Philippines`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `PL`.
    temp6-text = `Poland`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `PT`.
    temp6-text = `Portugal`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `QA`.
    temp6-text = `Qatar`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `RO`.
    temp6-text = `Romania`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `RU`.
    temp6-text = `Russia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `SA`.
    temp6-text = `Saudi Arabia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `SN`.
    temp6-text = `Senegal`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `RS`.
    temp6-text = `Serbia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `SG`.
    temp6-text = `Singapore`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `SK`.
    temp6-text = `Slovakia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `SI`.
    temp6-text = `Slovenia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `ZA`.
    temp6-text = `South Africa`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `KR`.
    temp6-text = `South Korea`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `ES`.
    temp6-text = `Spain`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `SE`.
    temp6-text = `Sweden`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `CH`.
    temp6-text = `Switzerland`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `TN`.
    temp6-text = `Tunisia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `TR`.
    temp6-text = `Turkey`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `UG`.
    temp6-text = `Uganda`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `UA`.
    temp6-text = `Ukraine`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `AE`.
    temp6-text = `United Arab Emirates`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `GB`.
    temp6-text = `United Kingdom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `YE`.
    temp6-text = `Yemen`.
    INSERT temp6 INTO TABLE temp5.
    t_countries = temp5.

    SORT t_countries BY text AS TEXT ASCENDING.

  ENDMETHOD.

ENDCLASS.
