<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width:device-width,initial-scale=1.0">
<title>Home</title>
<link rel="stylesheet" href="resources/css/bootstrap.min.css">
<link rel="stylesheet" href="resources/css/slick-theme.css">
<link rel="stylesheet" href="resources/css/slick.css">
<link rel="stylesheet" href="resources/css/animate.css">
<link rel="stylesheet" href="resources/css/main.css">
<link rel="stylesheet" href="resources/animation/reset.css"> <!-- CSS reset -->
<link rel="stylesheet" href="resources/animation/style.css"> <!-- CSS reset -->
<link rel="stylesheet" href="resources/css/loading.min.css"> <!-- CSS reset -->

<script src="resources/js/modernizr.js"></script>
<script src="resources/js/jquery-1.12.0.min.js"></script>
<script src="resources/js/map.js"></script>
<script src="resources/js/slick.min.js"></script>
<script src="resources/js/script.js"></script>
<script src="resources/js/counter.js"></script>
<script src="resources/js/jquery.lightbox_me.js"></script>
<script src="resources/js/velocity.min.js"></script>
<script src="resources/js/velocity.ui.min.js"></script>
<script src="resources/js/main.js"></script>
<script src="resources/js/jquery.loading.min.js"></script>

<style type="text/css">
.cd-user-modal {
  visibility: hidden;
  opacity: 0;
  transition: opacity 0.3s, visibility 0.3s;
} 
.cd-user-modal.is-visible {
  visibility: visible;
  opacity: 1;
}
footer {
	margin-top: 30%;
}

#profile_id {
	margin-top: 45%;
}

#btn_logout {
	text-align: center;
}

.da-btn da-booking-btn hvr-sweep-to-right-inverse {
	margin: 0 auto;
	margin-left: 50%;
}
#playListDiv {
	padding-bottom: 300px;
}
.col-sm-3{
	width: 50%;
}
/* #login{
	/* background-image: url("resources/images/main-img-bg3.jpg"); 
	background-color: rgba(255,0,0,0.3);
	width: 600px;
	height: 800px;
} */
#login {
	background-color:  rgba(0, 49, 44,0.6);
    -moz-border-radius: 6px;
    /* background: #eef2f7; */
    -webkit-border-radius: 6px;
    border: 1px solid #536376;
   /*  -webkit-box-shadow: rgba(0, 49, 44,.6) 0px 2px 12px;
    -moz-box-shadow:  rgba(0, 49, 44,.6) 0px 2px 12px;; */
    padding: 14px 22px;
    width: 400px;
    position: relative;
    display: none;
}
#login #loginForm {
    margin-top: 13px;
}
#login label {
    display: block;
    margin-bottom: 10px; 
    color: #536376;
    font-size: .9em;
}

#login label input {
    display: block;
    width: 393px;
    height: 31px;
    background-position: -201px 0;
    padding: 2px 8px;
    font-size: 1.2em;
    line-height: 31px;
}
.mainImage {
	background-image: url("resources/images/main-img-bg3.jpg");
	background-repeat: no-repeat;
	background-position: center center;
}
</style>
<script>

	$(function(e) {
		/* $("body").data("hijacking", 'on');
		$("body").data("animation", 'gallery'); */
		if("${empty loginUser}") {
	        $("#login").lightbox_me({centered: true, preventScroll: true, onLoad: function() {
				$("#login").find("input:first").focus();
			}});
	        e.preventDefault();
		}
		else {
			$('#next').trigger("click");
		}
		
		$(".mainImage").on('mousedown', function(event) {
			event.preventDefault();
		});
		
	});
	var user_id = null;
	var user_nickname = null;

	function logout() {
		location.href = "logout";
	}

	function updateForm() {
		location.href = "updateForm";
	}
	
	function makingRoomPopUp() {
		window.open("makingRoomPopUp?id="+user_id, "Room Making Setting", 'width=400, height=600');
	}
	
	function goToRoomList(){
		location.href = "/escape/roomList?nickname="+user_nickname;		
	}
	
	
	
	var sw = true;
	function login() {
		$.showLoading();
		var id = $("#id").val();
		var pw = $("#pw").val();
		var sendData = {"id" : id, "pw" : pw};
		$.ajax({
			url: "login",
			method: "post",
			data: sendData,
			success: function(resp) {
				if(resp != null) {
					/* closeLightbox(); */
					//$ele.lightbox_me();
					//$ele.trigger('close');
					//nextSection();
					$("#loginBtn").addClass("close sprited");
					if(sw){
						$('#loginBtn').trigger("click");
						sw = false;
					}//if
					alert(resp.id);
					user_id = resp.id;
					user_nickname = resp.nickname;
					$.hideLoading();
					$('#next').trigger("click");
					resp = false;
				}
				else {
					$.hideLoading();
				}
			}
		});
		
		//$("#loginForm").submit();
	}
	
	function join() {  
		location.href = "joinForm";
	}
</script>

</head>
<body data-hijacking="on" data-animation="gallery">
<input type="hidden" id="animation" value="gallery">
<input type="hidden" id="hijacking" value="on">

	<section class="cd-section visible" id="mainImage">
		<div class="mainImage">
			<div>
				<div id="login">
		    	<h2>Login</h2>
			    <form class="da-form-container da-margin-top-15" action="login" method="post" id="loginForm">
			        <label><strong>ID:</strong> <input class="da-padding-left-15" type="text" name="id" id="id" placeholder="ID"/></label>
			        <label><strong>PW:</strong> <input class="da-padding-left-15" type="password" name="pw" id="pw" placeholder="PW"/></label>
			        <div id="actions">
			        </div>
			    </form>
			    <button type="button" id="loginBtn" class="da-btn hvr-sweep-to-right" onclick="login()">Login</button>
				<button type="button" class="da-btn hvr-sweep-to-right" onclick="join()">Join</button>
			</div>
		</div>
		</div>
	</section>
	<section class="cd-section">
		<div>
			<input type="hidden" id="room_no" name="no" value="">
	
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-1 col-md-2 col-sm-2 col-xs-5">
						<div class="da-header-logo-container">
							<a href="mainForm"> <img src="resources/images/logo.png" alt="Escape Room" class="img-responsive"></a>
						</div>
					</div>
					<div class="col-lg-9 col-md-7 col-sm-7 col-xs-2 da-text-align-right">
						<div class="da-menu-button">
							<img src="resources/images/menu-icon.png" alt="Menu">
						</div>
						<nav>
							<ul class="da-menu">
								<li class="da-active-menu-link"><span class="da-hover-menu-line"></span> <a href="#">Home</a></li>
								<li><span class="da-hover-menu-line"></span><a href="faq.html">FAQ</a></li>
								<li><span class="da-hover-menu-line"></span> <a href="#">Blog</a>
									<ul>
										<li><a href="blog-left-sidebar.html">BLOG LISTING WITH LEFT SIDEBAR</a></li>
										<li><a href="blog-left-sidebar-details.html">BLOG LISTING WITH LEFT SIDEBAR Details</a></li>
										<li><a href="blog-right-sidebar.html">BLOG LISTING WITH right SIDEBAR</a></li>
										<li><a href="blog-right-sidebar-details.html">BLOG LISTING WITH right SIDEBAR Details</a></li>
									</ul>
								</li>
								<li><span class="da-hover-menu-line"></span> <a href="#">Contact</a>
									<ul>
										<li><a href="contacts.html">Contacts1</a></li>
										<li><a href="contacts-2.html">Contacts2</a></li>
									</ul>
								</li>
								<li class="da-active-menu-link"><span class="da-hover-menu-line"></span><a href="#" onclick="logout()">Logout</a></li>
							</ul>
						</nav>
					</div>
				</div>
			</div>
		
		<div class="da-bg-container" id="playListDiv">
			<div class="container">
				<h2>Let the game begin</h2>
				<div class="row da-game-row">
					<div class="col-md-5 col-sm-5 col-xs-12 da-margin-top-30">
						<div class="da-step-container da-text-align-right da-left-animated-block">
							<p class="da-step-title da-font-montserrat"><span class="da-num-mobile da-red-text da-padding-right-15">01</span>
							Game Editor<span class="da-num-screen da-red-text da-padding-left-15">01</span></p>
							<p>Logical problems and puzzles. No physical effort. Only wit and observation. Everything is in your head.</p>
						</div>
					</div>
					<div class="col-md-5 col-md-offset-2 col-sm-5 col-sm-offset-2 col-xs-12 da-margin-top-30 da-right-animated-block">
						<div class="da-step-container">
							<p class="da-step-title da-font-montserrat"><span class="da-red-text da-padding-right-15">02</span>
							<a href="#" onclick="goToRoomList()">Game Room List</a></p>
							<p>Exactly 1 hour to find a way out and get out of the quest of the room, thinking all the fun and interesting puzzles on your heroic journey.</p>
						</div>
					</div>
				</div>
				<div class="row da-game-row">
					<div class="col-md-5 col-sm-5 col-xs-12 da-margin-top-30">
						<div class="da-step-container da-text-align-right da-left-animated-block">
							<p class="da-step-title da-font-montserrat"><span class="da-num-mobile da-red-text da-padding-right-15">03</span>
							<a href="/escape/updateForm">Change Info</a>
							<span class="da-num-screen da-red-text da-padding-left-15">03</span></p>
							<p>For the whole family and for your friends ! Your team - the key to a successful passing game. Trust and partner nayditie output.</p>
						</div>
					</div>
					<div class="col-md-5 col-md-offset-2 col-sm-5 col-sm-offset-2 col-xs-12 da-margin-top-30 da-right-animated-block">
						<div class="da-step-container">
							<p class="da-step-title da-font-montserrat"><span class="da-red-text da-padding-right-15">04</span>
							<a href="#" onclick="makingRoomPopUp()" id="makeRoomBtn">Make Game Room</a></p>
							<p>This is an unforgettable adventure in the exciting world of mystery. Only positive emotions and vivid feeling for the entire company.</p>
						</div>
					</div>
				</div>
				<div class="da-positioned-block">
					<img src="resources/images/${loginUser.profile}.png" alt="Key">
					<p align="center" id="profile_id">${loginUser.id}</p>
					<p align="center">${loginUser.nickname}</p>
				</div>
			</div>
		</div>
		<div class="da-bg-container">
			<div class="container">
				<h2 class="da-underline-title da-white-text">Game Playlist</h2>
				<div class="row da-margin-top-30 da-text-news">
						<div class="col-sm-4 col-xs-12 visible animated fadeInUp">
							<div class="da-margin-bottom-30 da-post-pic">
								<img src="resources/images/blog-img1.jpg" alt="new">
							</div>
							<div class="da-title-block">
								<div class="da-date-container br-container-date da-text-align-center da-font-montserrat">
									<p> <span class="da-font-big">23</span> oct</p>
								</div>
								<p class="da-blog-title da-margin-left-20pr"><a href="#">UT ENIM AD MINIM VENIAM, QUIS NOSTRUD</a></p>
							</div>
							<p class="da-margin-top-30 da-gray-text">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit</p>
							<div class="da-margin-top-30 da-details-container">
								<a href="#" class="da-gray-text"><i class="fa fa-user"></i>John Doe</a>
								<a href="#" class="da-gray-text"><i class="fa fa-folder-open"></i>Design</a>
								<a href="#" class="da-gray-text"><i class="fa fa-comments"></i>80</a>
								<a href="#" class="da-gray-text"><i class="fa fa-eye"></i>456</a>
							</div>
						</div>
						<div class="col-sm-4 col-xs-12 visible animated fadeInUp">
							<div class="da-margin-bottom-30  da-post-pic">
								<img src="resources/images/blog-img1.jpg" alt="new">
							</div>
							<div class="da-title-block">
								<div class="da-date-container br-container-date da-text-align-center da-font-montserrat">
									<p> <span class="da-font-big">21</span> oct</p>
								</div>
								<p class="da-blog-title da-margin-left-20pr"><a href="#">SED UT PERSPICIATIS UNDE OMNIS ISTE NATUS</a></p>
							</div>
							<p class="da-margin-top-30 da-gray-text">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit</p>
							<div class="da-margin-top-30 da-details-container">
								<a href="#" class="da-gray-text"><i class="fa fa-user"></i>John Doe</a>
								<a href="#" class="da-gray-text"><i class="fa fa-folder-open"></i>Design</a>
								<a href="#" class="da-gray-text"><i class="fa fa-comments"></i>80</a>
								<a href="#" class="da-gray-text"><i class="fa fa-eye"></i>456</a>
							</div>
						</div>
						<div class="col-sm-4 col-xs-12 visible animated fadeInUp">
							<div class="da-margin-bottom-30 da-post-pic">
								<img src="resources/images/blog-img1.jpg" alt="new">
							</div>
							<div class="da-title-block">
								<div class="da-date-container br-container-date da-text-align-center da-font-montserrat">
									<p> <span class="da-font-big">17</span> oct</p>
								</div>
								<p class="da-blog-title da-margin-left-20pr"><a href="#">FUSCE NON ANTE SED LOREM RUTRUM FEUGIAT</a></p>
							</div>
							<p class="da-margin-top-30 da-gray-text">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit</p>
							<div class="da-margin-top-30 da-details-container">
								<a href="#" class="da-gray-text"><i class="fa fa-user"></i>John Doe</a>
								<a href="#" class="da-gray-text"><i class="fa fa-folder-open"></i>Design</a>
								<a href="#" class="da-gray-text"><i class="fa fa-comments"></i>80</a>
								<a href="#" class="da-gray-text"><i class="fa fa-eye"></i>456</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<nav>
		<ul class="cd-vertical-nav">
			<li><a href="#0" class="cd-prev inactive">Next</a></li>
			<li><a href="#0" id="next" class="cd-next">Prev</a></li>
		</ul>
	</nav>

<!-- <div id="login">
	<div class="col-sm-3">
		<form class="da-form-container da-margin-top-15" action="login" method="post" id="loginForm">
			<input class="da-padding-left-15" type="text" name="id" id="id" placeholder="ID">
			<input class="da-padding-left-15" type="password" name="pw" id="pw" placeholder="PW">
		</form>
		<button type="button" class="da-btn hvr-sweep-to-right" onclick="login()">Login</button>
		<button type="button" class="da-btn hvr-sweep-to-right" onclick="join()">Join</button>
	</div>
</div> -->
<%-- </c:if>
 --%>
</body>
</html>
