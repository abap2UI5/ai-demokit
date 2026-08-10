#!/usr/bin/env python3
"""Throwaway helper: the rewrites every sap.ui.table product-sample port shares.

Turns the mechanical tmp-x2a.py output into the port's view chain: JSON key
bindings become the ABAP field names, the controller's two Available
formatters become precomputed columns, the multi-line typed bindings become
`|\\{ … \\}|` templates and the two derived collections get their real paths.
"""
B = chr(92)

TOAST = (
    "%s)->a( n = `press` v = client->_event_client(\n"
    "%s          val   = client->cs_event-control_global\n"
    "%s          t_arg = VALUE #( ( `MESSAGE_TOAST` )\n"
    "%s                           ( `show` )\n"
    "%s                           ( `Details for product with id {0}` )\n"
    "%s                           ( `${PRODUCTID}` ) ) )")

FIELDS = (
    ('{Name}', '{NAME}'), ('{ProductId}', '{PRODUCTID}'), ('{Quantity}', '{QUANTITY}'),
    ('{Status}', '{STATUS}'), ('{Price}', '{PRICE}'), ('{CurrencyCode}', '{CURRENCYCODE}'),
    ('{SupplierName}', '{SUPPLIERNAME}'), ('{ProductPicUrl}', '{PRODUCTPICURL}'),
    ('{Category}', '{CATEGORY}'), ('{Available}', '{AVAILABLE}'),
)


def details_toast(indent):
    return TOAST % ((' ' * indent,) * 6)


def rewire(text):
    s = text
    s = s.replace("`{         path: 'Heavy',         type: 'sap.ui.model.type.String'        }`",
                  "|" + B + "{ path: 'HEAVY', type: 'sap.ui.model.type.String' " + B + "}|")
    s = s.replace("`{         path: 'DeliveryDate',         type: 'sap.ui.model.type.Date',"
                  "         formatOptions: {source: {pattern: 'timestamp'}}        }`",
                  "|" + B + "{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: "
                  + B + "{ source: " + B + "{ pattern: 'timestamp' " + B + "} " + B + "} " + B + "}|")
    s = s.replace("`{         path: 'Quantity',         type: 'sap.ui.model.type.Integer'        }`",
                  "|" + B + "{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' " + B + "}|")
    for a, b in FIELDS:
        s = s.replace('`' + a + '`', '`' + b + '`')
    s = s.replace("`{ path: '/Suppliers', templateShareable: false }`",
                  "|" + B + "{ path: '{ client->_bind( val = t_suppliers path = abap_true ) }',"
                  " templateShareable: false " + B + "}|")
    s = s.replace("`{ path: '/Categories', templateShareable: false }`",
                  "|" + B + "{ path: '{ client->_bind( val = t_categories path = abap_true ) }',"
                  " templateShareable: false " + B + "}|")
    return s
