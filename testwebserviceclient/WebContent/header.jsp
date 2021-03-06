<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<% HttpSession sesi = request.getSession(true); %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/AJS_style.css" />
<link rel="stylesheet" type="text/css" href="css/ddsmoothmenu.css" />
<link href="css/layout.css" rel="stylesheet" type="text/css" />
<link href="css/modal.css" rel="stylesheet" type="text/css" />
<script src="${pageContext.request.contextPath}/verify.js"></script>
<script src='${pageContext.request.contextPath}/ajax.js'></script>
<script type="text/javascript">
var kategori=new Array("Pangan", "Pakaian", "Elektronik", "Rangga", "Olahraga");
function getKategori(){
	var query = "SELECT DISTINCT kategori_barang FROM barang";
	var kategorilist = document.getElementById("kategorilist");
	sendQuery(query, function() {
		var jsonArray = JSON.parse(xmlhttp.responseText);
		var result="";
		for (var i = 0; i < jsonArray.result.length; i++) {
			result += "<li> <a href='kategori.jsp?id="+jsonArray.result[i]+"&laman=1'>"+kategori[jsonArray.result[i]-1] + "</a></l1>"; 
		}
		kategorilist.innerHTML = result;
	});
}

function getWelcome(){
	/*var query = "SELECT DISTINCT kategori_barang FROM barang";
	var DIV = document.getElementById("AJS_header");
	sendQuery(query, function() {
		var jsonArray = JSON.parse(xmlhttp.responseText);
		var result="";
		for (var i = 0; i < jsonArray.result.length; i++) {
			result += kategori[jsonArray.result[i]-1] + "</br>"; 
		}
		DIV.innerHTML = "ASDASDAS";
	});*/
}
function getNavbar(){
	var customnavbar = document.getElementById("customnavbar");
    if(window.XMLHttpRequest){
            xmlhttp = new XMLHttpRequest();
    }
    else{
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function(){
            if(xmlhttp.readyState==4&&xmlhttp.status==200){
                    customnavbar.innerHTML = xmlhttp.responseText;

                    if(err_login.innerHTML==""){
                            //Handle SESSION & LOCAL STORAGE
                            window.location="index.jsp";
                    }
            }
    };
    xmlhttp.open("GET","getNavbar",true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send();
}
function verLogin(){
	var username = document.forms['login']['username'].value;
	var password = document.forms['login']['password'].value;
	var err_login = document.getElementById("err_login");
	var query = "SELECT * FROM user where username ='"+username+"' AND password = '"+password+"'";
	var data = "username="+username+"&password="+password;
	var isLogin = false;
	sendQuery(query, function() {
		var jsonArray = JSON.parse(xmlhttp.responseText);
		var result="";
		if(jsonArray.result.length == 0){
			err_login.innerHTML = "Username or Password is Wrong Bro";
		}
		else{
			if(window.XMLHttpRequest){
				xmlhttp = new XMLHttpRequest();
			}
			else{
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
			xmlhttp.onreadystatechange=function(){
				if(xmlhttp.readyState==4&&xmlhttp.status==200){
					err_login.innerHTML = xmlhttp.responseText;
					if(err_login.innerHTML==""){
						//Handle SESSION & LOCAL STORAGE
						window.location="index.jsp";
					}
				}
			};
			xmlhttp.open("POST","verifyLogin",true);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			xmlhttp.send(data);
		}
	});
}
</script>
<title>RuserBa</title>
</head>
<body onload='getKategori();getWelcome()'>
<div id="AJS_body_wrapper">
	<div id="AJS_wrapper">
		<div id="AJS_header">
		<% 
			if((sesi== null)|| (sesi.getAttribute("username")==null)) {
			%>
				<div id='site_title'><h1><a href='index.jsp'>Ruko Serba Ada</a></h1></div>
			<%
			}
			else{
			out.print("<div id='site_title'><h1><a href='index.jsp'>Welcome</a>, <a href='profile.jsp'>"+ sesi.getAttribute("username")+"</a></h1></div>");
			}
			%>
		</div>
		<div id="AJS_menubar">
			<div id="top_nav" class="ddsmoothmenu">
				<ul id="customnavbar">

					<% 
				if((sesi== null)|| (sesi.getAttribute("username")==null)) {
				%>
					<li><a href="register.jsp">Sign Up</a></li>
					<li><a href="#login_form">Log in </a></li>
				<%
				}
				else{
				%>
					<li><a href="registercreditcard.jsp"> Register Credit Card </a></li>
					<li><a href="shoppingbag.jsp"> Shopping Bag </a></li>
					<li><a href="profile.jsp">Profile</a></li>
					<%
						if(sesi.getAttribute("username").equals("admin")){
							out.print("<li><a href='kategori.jsp?laman=1&id=1'>Admin Barang</a></li>");
						}
					%>
					<li><a href="logout.jsp">Log out</a></li>
				<%
				}
				%>
				</ul>
				<br style="clear: left" />
			</div> <!-- end of ddsmoothmenu -->	
    	</div> <!-- END of AJS_menubar -->
		<a href="#x" class="overlay" id="login_form" ></a>
        <div class="popup">
            <h2>Welcome Guest!</h2>
            <p>Please enter your login and password here</p>
            <form name="login" action="javascript:verLogin();" method="GET">
	            
	                Username : <input type="text" name="username"><br>
	                Password : <input type="password" name="password"><br>
	                <div id="err_login"></div><br>
	            	<input type="submit" value="Log In" />
	        </form>
            <a class="close" href="#close"></a>
        </div>
        
<div id="AJS_main">
	<div id="sidebar" class="float_r">
		<div class="sidebar_box"><span class="bottom"></span>
			<h3>Search Option : </h3>
	        		<form name="search" action="search.jsp" method="get">
						<input type="hidden" name="laman" value="1">
						<input type="text" name="searched" id="keyword" title="keyword" onfocus="clearText(this)" onblur="clearText(this)" class="txt_field" />
						<input type="submit" value="Cari" alt="Search" id="searchbutton" title="Search" class="sub_btn"  />
		        		<p>Kategori : </p>
		        		<select name="s_kategori">
							<option value="1">Pangan</option>
							<option value="2">Pakaian</option>
							<option value="3">Elektronik</option>
							<option value="4">Rumah Tangga</option>
							<option value="5">Olah Raga</option>
						</select><br>
						<p>Harga kurang dari : </p>
						<input type="text" name="s_harga" id="keyword" title="keyword" onfocus="clearText(this)" onblur="clearText(this)" class="txt_field" />
					</form>

	            	<h3>Kategori</h3>   
	                	<div class="content"> 
	                	<ul id="kategorilist" class="sidebar_list">
						</ul>
						</div>
		</div>
	</div>
