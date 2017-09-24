<!doctype html>
<html>
<head>
<title><cfoutput>Credit Note List :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
    <cfquery name="MemberList">
SELECT CreditNoteID, CreditNoteDate, BranchId, TotalAmount, CustomerId
FROM vwCustCreditNoteTotalAmt
ORDER BY CreditNoteDate ASC 
  </cfquery>
<h4>Credit-Note Details <cfoutput>(#MemberList.recordcount# Records)</cfoutput></h4>

<div id="RightColumn">
<br />

  


<div align="center">

<cfform name="myForm" width="70%" >

      <cfgrid name="data" query="MemberList" height="400" width="500" rowheaders="no" format="html" highlighthref="no">
      	<cfgridcolumn header="Date" name="CreditNoteDate" type="date"/>
         <cfgridcolumn header="Invoice No" name="CreditNoteID"  href="../reports/CreditNotePrnt.cfm" hrefkey="CreditNoteID"/>
         <cfgridcolumn header="Branch" name="BranchId" />
         <cfgridcolumn header="Amount"  name="TotalAmount"/>
         <cfgridcolumn header="Customer Id" name="CustomerId" display="false" />
      </cfgrid>

<br />

</cfform>

</div>
</div>


</div>  
</div>
</body>
</html>