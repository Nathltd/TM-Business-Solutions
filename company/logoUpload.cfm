<!--- Windows Example ---> 
<!--- Check to see if the Form variable exists. ---> 
<cfset uploadFile = "#expandpath("/")##request.bkup#invoices\images">
<cfif isDefined("Form.FileContents") > 
    <!--- If TRUE, upload the file. ---> 
    <cffile action = "upload"  
        fileField = "FileContents"  
        destination = "#uploadFile#"  
        accept = "image/jpeg"  
        nameConflict = "overwrite"> 
        <cfquery>
        UPDATE invoiceOptions
        SET
        logo = '#cffile.serverfile#'
        </cfquery>
<cfelse> 
    <!--- If FALSE, show the Form. --->
    <cfquery name="option">
select logo, terms, footer, vat, tin
from invoiceOptions
</cfquery> 
<cfoutput>    Folder: #uploadFile# <br>
<img id="image" src="../Invoices/images/#option.logo#" alt="logo" width="540" />
    <form method="post" action=#cgi.script_name#  
        name="uploadForm" enctype="multipart/form-data"> 
        <input name="FileContents" type="file" value="#Trim(Option.logo)#"> 
        <br> 
        <input name="submit" type="submit" value="Upload File">  
    </form> 
    </cfoutput>
</cfif>