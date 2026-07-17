CLASS z2ui5_cl_ai_app_423 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_country,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_country.
    DATA t_countries TYPE STANDARD TABLE OF ty_s_country WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_423 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " Data of the mock model sap/ui/demo/mock/countriesExtendedCollection.json used by the original sample
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


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->open( `content`
                )->open( `ComboBox`
                    )->a( n = `items` v = |\{ path: '{ client->_bind_edit( val = t_countries path = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
