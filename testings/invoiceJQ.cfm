<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Proposed TM Jquery Layout Template</title>
</head>
<link rel="stylesheet" type="text/css" href="googleJquery-ui.css"/>

<script src="googleJquery-min.js"></script>
<script src="googleJquery-ui.min.js"></script>
<body class=" ui-widget">
<div align="center">
<div class="mainBody">
<cfform>
<fieldset>

<legend><strong>Invoice Details</strong></legend>
<table width="874">
<tr>
<td width="135"><label for="customer">Customer: </label></td>
<td width="144"><cfinput type="text" id="customer"  name="customer" tabindex="1" tooltip="Customer's Name" autofocus /></td>
<td width="281">&nbsp;</td>
<td width="88"><label for="invDate">Date: </label></td>
<td width="202"><cfinput type="datefield" id="invDate"  name="invDate" size="8" tabindex="2" tooltip="Invoice Date" placeholder="#dateformat(now(),"dd/mm/yyyy")#" mask="dd/mm/yyyy"/></td>
<script>$("#invDate").datepicker();</script>
</tr>
<tr>
<td><label for="invoiceNo">Invoice No: </label></td>
<td><cfinput type="text" id="invoiceNo"  name="invoiceNo" tabindex="3" tooltip="Invoice No." /></td>
<td>&nbsp;</td>
<td><label for="branch">Location: </label></td>
<td><cfselect name="branch" id="branch" tabindex="4" tooltip="Sales Location">
	<option value="Ikeja">Ikeja</option>
    </cfselect>
</tr>
<tr>
<td><label for="account">Account: </label></td>
<td><cfinput type="text" id="account"  name="account" readonly tabindex="5" tooltip="Sales Account"/></td>
<td>&nbsp;</td>
<td><label for="author">Authorised: </label></td>
<td><cfselect name="author" id="author" tabindex="6" tooltip="Sales Rep.">
	<option value="Adanna">Adanna</option>
    </cfselect></td>
</tr>
<tr>
<td><label for="amount">Amount Paid: </label></td>
<td><cfinput type="text" id="amountpd"  name="amountpd" readonly tabindex="7" tooltip="Cash collected for this invoice" /></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td></td>
<td></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td colspan="5" align="right"></td>
</tr>
</table>
<table width="874">
  <tr>
    <td>Item</td>
    <td>Description</td>
    <td>Qty</td>
    <td>Unit Price</td>
    <td>Amount</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><cfinput type="text" id="item"  name="item" size="12" tooltip="Item Code" tabindex="8"/></td>
    <td><cfinput type="text" id="description"  name="description" readonly="yes" size="37" tooltip="Item Description" tabindex="9"/></td>
    <td><cfinput type="text" id="qty"  name="qty" size="3" tooltip="Item Quantity" tabindex="10"/></td>
    <td><cfinput type="text" id="price"  name="price" size="7" tooltip="Unit Price" tabindex="11"/></td>
    <td><cfinput type="text" id="amount"  name="amount" size="8" tooltip="Amount for this item" tabindex="12"/></td>
    <td align="right"><cfinput type="button" name="Button" id="Button" tabindex="13" tooltip="Add this item to the invoice" value="Add"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><label for="total">Total: </label></td>
    <td><cfinput type="text" id="total"  name="total" size="8" readonly tooltip="Total amount for this invoice" tabindex="12"/></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><label for="balance">Balance: </label></td>
    <td><cfinput type="text" id="balance"  name="balance" size="8" readonly tooltip="Cash to be balanced" tabindex="12"/></td>
    <td>&nbsp;</td>
  </tr>
</table>

</fieldset>
</cfform>
</div>
</div>
</body>
</html>