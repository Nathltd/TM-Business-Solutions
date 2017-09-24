<!doctype html>
<html>
<head>
<title><cfoutput>Debit Note List :: #request.title#</cfoutput></title>
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
SELECT DebitNoteID, DebitNoteDate, BranchId, TotalAmount, VendorId
FROM vwDebitNoteTotalAmt
ORDER BY DebitNoteDate ASC 
  </cfquery>
<h4>Debit-Note Details <cfoutput>(#MemberList.recordcount# Records)</cfoutput></h4>

<div id="RightColumn">
<br />

  


<div align="center">

<cfform name="myForm" width="70%" >

      <cfgrid name="data" query="MemberList" height="400" width="500" rowheaders="no" format="html" highlighthref="no">
      	<cfgridcolumn header="Date" name="DebitNoteDate" type="date"/>
         <cfgridcolumn header="Invoice No" name="DebitNoteID"  href="../reports/DebitNotePrnt.cfm" hrefkey="DebitNoteID"/>
         <cfgridcolumn header="Branch" name="BranchId" />
         <cfgridcolumn header="Amount"  name="TotalAmount"/>
         <cfgridcolumn header="Vendor Id" name="VendorId" display="false" />
      </cfgrid>

<br />

</cfform>

</div>
</div>


</div>  
</div>
</body>
</html>