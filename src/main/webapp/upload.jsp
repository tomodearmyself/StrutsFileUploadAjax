<%@ page import="org.apache.struts.action.*,
                 java.util.Iterator,
                 org.apache.struts.webapp.upload.UploadForm"%>
<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<html>
<head>
<title>File Upload Example</title>
<script type="text/javascript" src="webjars/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript">
$(function() {
  $('#upButton').on('click', function () {

    let $upfile = $('input[name="theFile"]');
    let fd = new FormData();
    fd.append("theFile", $upfile.prop('files')[0]);

      $.ajax({
          url:'<html:rewrite page="/upload.do?queryParam=Successful"/>',
          type:'post',
          data: fd,
          processData: false,
          contentType: false,
          cache: false,
      }).done(function (data) {
          //alert(data);
          $("#results").html(data);
      }).fail(function() {
          alert("fail");
      });
  });
});
</script>
</head>

<body>
<!-- Find out if the maximum length has been exceeded. -->
<logic:present name="<%= Action.ERROR_KEY %>" scope="request">
    <%
        ActionErrors errors = (ActionErrors) request.getAttribute(Action.ERROR_KEY);
        //note that this error is created in the validate() method of UploadForm
        Iterator iterator = errors.get(UploadForm.ERROR_PROPERTY_MAX_LENGTH_EXCEEDED);
        //there's only one possible error in this
        ActionError error = (ActionError) iterator.next();
        pageContext.setAttribute("maxlength.error", error, javax.servlet.jsp.PageContext.REQUEST_SCOPE);
    %>
</logic:present>
<!-- If there was an error, print it out -->
<logic:present name="maxlength.error" scope="request">
    <font color="red"><bean:message name="maxlength.error" property="key" /></font>
</logic:present>
<logic:notPresent name="maxlength.error" scope="request">
    Note that the maximum allowed size of an uploaded file for this application is two megabytes.
    See the /WEB-INF/struts-config.xml file for this application to change it.
</logic:notPresent>

<br /><br />
<!--
  The most important part is to declare your form's enctype to be "multipart/form-data",
  and to have a form:file element that maps to your ActionForm's FormFile property
-->
<html:form action="upload.do?queryParam=Successful" enctype="multipart/form-data">

  Please enter some text, just to demonstrate the handling of text elements as opposed to file elements:<br />
  <html:text property="theText" /><br /><br />

  Please select the file that you would like to upload:<br />
  <html:file property="theFile" /><br /><br />

        If you would rather write this file to another file, please check here:
        <html:checkbox property="writeFile" /><br /><br />

        If you checked the box to write to a file, please specify the file path here:<br />
        <html:text property="filePath" /><br /><br />

  <html:submit />


</html:form>

<button id="upButton" type="button">ajax</button>
<div id="results"></div>

</body>
</html>
