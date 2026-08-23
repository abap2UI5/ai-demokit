" @keywords combobox combo box sap.m comboboxvalidation verticallayout label item
" @summary The combo box control could be restricted to allow selection only from the items in the list.
CLASS z2ui5_cl_smpc_app_475 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_country,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_country.
    TYPES ty_t_country TYPE STANDARD TABLE OF ty_s_country WITH EMPTY KEY.

    DATA t_countries TYPE ty_t_country.

    DATA selected_key     TYPE string.
    DATA value            TYPE string.
    DATA value_state      TYPE string VALUE `None`.
    DATA value_state_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_475 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `Choose a country:`
                )->a( n = `labelFor` v = `idComboBox`
            " handleChange validates in the controller - validation is business logic,
            " so it happens in ABAP and the two value-state properties are bound
            )->ele( `ComboBox`
                )->a( n = `id`             v = `idComboBox`
                )->a( n = `items`          v = |\{ path: '{ client->_bind( val = t_countries path = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|
                )->a( n = `selectedKey`    v = client->_bind( selected_key )
                )->a( n = `value`          v = client->_bind( value )
                )->a( n = `valueState`     v = client->_bind( value_state )
                )->a( n = `valueStateText` v = client->_bind( value_state_text )
                )->a( n = `change`         v = client->_event( `CHANGE` )

                )->tag( n = `Item` ns = `core`
                    )->a( n = `text` v = `{TEXT}`
                    )->a( n = `key`  v = `{KEY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `CHANGE`.

      " a typed value with no matching key is the error case of the original
      IF selected_key IS INITIAL AND value IS NOT INITIAL.
        value_state      = `Error`.
        value_state_text = `Please enter a valid country!`.
      ELSE.
        value_state      = `None`.
        CLEAR value_state_text.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /CountriesCollection of ui5/mock/countriesExtendedCollection.json
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
        ( key = `YE` text = `Yemen` ) ).

  ENDMETHOD.

ENDCLASS.
