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
<link rel="stylesheet" href="resources/css/loading.min.css"> <!-- CSS reset -->

<script src="resources/js/modernizr.js"></script>
<script src="resources/js/jquery-1.12.0.min.js"></script>
<script src="resources/js/map.js"></script>
<script src="resources/js/slick.min.js"></script>
<script src="resources/js/script.js"></script>
<script src="resources/js/counter.js"></script>
<script src="resources/js/jquery.lightbox_me.js"></script>
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
#loginH2 {
	margin-top: 10px;
	margin-bottom: 10px;
}
#login label input {
	width: 300px;
}
</style>

<script>

$(function(e) {
	/* $("body").data("hijacking", 'on');
	$("body").data("animation", 'gallery'); */
	$("#loginBtn").addClass("close sprited");
	if("${empty loginUser.profile}") {
        $("#login").lightbox_me({centered: true, preventScroll: true, onLoad: function() {
			$("#login").find("input:first").focus();
		}});
        //e.preventDefault();
	}
	else {
		$("#loginBtn").addClass("close sprited");
	}
	
	$(".mainImage").on('mousedown', function(event) {
		event.preventDefault();
	});
	
	//$("#loginBtn").on('click', login);
	
	//$("#logoutBtn").on('click', logout);
	
});
//var user_id = null;
//var user_nickname = null;

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
				/* if(sw){
					$('#loginBtn').trigger("click");
					sw = false;
				}//if */
				/* else {
					sw = true;
				} */
				//$.fn.lightbox_me.closeLightbox();
				$("loginId").text(resp.id);
				$("loginProfile").attr("src", "resources/images/" + resp.profile + ".png");
				$("loginNickname").text(resp.nickname);
				$.hideLoading();
			}
			else {
				$.hideLoading();
			}
		}
	});
}

function join() {  
	location.href = "joinForm";
}

</script>

</head>
<body>
<div class="mainImage">
	<div>
		<div id="login">
    	<h2 id="loginH2">Login</h2>
    	<form class="da-form-container da-margin-top-15">
	        <label><strong>ID:</strong> <input class="da-padding-left-15" type="text" name="id" id="id" placeholder="ID"/></label>
	        <label><strong>PW:</strong> <input class="da-padding-left-15" type="password" name="pw" id="pw" placeholder="PW"/></label>
	        <!-- <div id="actions"> -->
			    <button type="button" id="loginBtn" class="da-btn hvr-sweep-to-right" onclick="login()">Login</button>
				<button type="button" class="da-btn hvr-sweep-to-right" onclick="join()">Join</button>
	        <!-- </div> -->
	    </form>
		</div>
	</div>
</div>
<header>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-1 col-md-2 col-sm-2 col-xs-5">
				<div class="da-header-logo-container">
					<a href="mainForm">
						<img src="resources/images/logo.png" alt="Escape Room" class="img-responsive">
					</a>
				</div>
			</div>
			<!-- <div class="col-lg-2 col-md-3 col-sm-3 col-xs-5">
				<div class="da-header-location">
					<a href="#" class="da-text-color-white da-font-weight-semibold"><i class="fa fa-map-marker"></i>New York</a>
					<ul>
						<li><a href="#" class="da-text-color-white da-font-weight-semibold"><i class="fa fa-map-marker"></i>London</a></li>
						<li><a href="#" class="da-text-color-white da-font-weight-semibold"><i class="fa fa-map-marker"></i>Berlin</a></li>
					</ul>
				</div>
			</div> -->
			<div class="col-lg-9 col-md-7 col-sm-7 col-xs-2 da-text-align-right">
				<div class="da-menu-button">
					<img src="resources/images/menu-icon.png" alt="Menu">
				</div>
				<nav>
					<ul class="da-menu">
						<li class="da-active-menu-link"><span class="da-hover-menu-line"></span>
							<a href="#">Home</a>
							<!-- <ul>
								<li><a href="home-1.html">Home1</a></li>
								<li><a href="home-2.html">Home2</a></li>
							</ul> -->
						</li>
						<!-- <li><span class="da-hover-menu-line"></span><a href="#da-rooms-id">Rooms</a></li>
						<li><span class="da-hover-menu-line"></span>
							<a href="#">Pages</a>
							<ul>
								<li><a href="booking-room.html">Booking room</a></li>
								<li><a href="not-found.html">Page Not Found</a></li>
								<li><a href="not-found-2.html">Page Not Found2</a></li>
							</ul>
						</li> -->
						
						<li><span class="da-hover-menu-line"></span>
							<a href="#">Blog</a>
							<ul>
								<li><a href="blog-left-sidebar.html">BLOG LISTING WITH LEFT SIDEBAR</a></li>
								<li><a href="blog-left-sidebar-details.html">BLOG LISTING WITH LEFT SIDEBAR Details</a></li>
								<li><a href="blog-right-sidebar.html">BLOG LISTING WITH right SIDEBAR</a></li>
								<li><a href="blog-right-sidebar-details.html">BLOG LISTING WITH right SIDEBAR Details</a></li>
							</ul>
						</li>
						<!-- <li><span class="da-hover-menu-line"></span>
							<a href="#">Contact</a>
							<ul>
								<li><a href="contacts.html">Contacts1</a></li>
								<li><a href="contacts-2.html">Contacts2</a></li>
							</ul>
						</li> -->
						<li><span class="da-hover-menu-line"></span>
							<a href="#" onclick="updateForm()">Member Info</a>
							<!-- <ul>
								<li><a href="contacts.html">Contacts1</a></li>
								<li><a href="contacts-2.html">Contacts2</a></li>
							</ul> -->
						</li>
						<li><span class="da-hover-menu-line"></span><a href="faq.html">FAQ</a></li>
						<li class="da-active-menu-link"><span class="da-hover-menu-line"></span>
							<a href="#" onclick="logout()">Logout</a>
							<!-- <ul>
								<li><a href="home-1.html">Home1</a></li>
								<li><a href="home-2.html">Home2</a></li>
							</ul> -->
						</li>
					</ul>
				</nav>
			</div>
		</div>
	</div>
</header>
	
	<!-- <div class="container-fluid">
		<div class="da-banner-slider da-inner-banner-slider">
			<div class="row">
				<div class="col-md-12 col-sm-12">
					<div class="da-main-banner background-image" data-image="resources/image/house.jpg">
						<div class="da-main-title">
							<h1>Horror Manifold</h1>
							<div class="da-breadcrumbs">
								<ul>
									<li><a href="#">Home</a></li>
									<li><a class="da-active-link" href="#">Horror Manifold</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div> -->

	<div class="da-bg-container da-padding-bottom-200">
	<div class="container">
		<h2 class="da-title-icon da-margin-bottom-0">Let the game begin</h2>
		<div class="row da-game-row">
			<div class="col-md-5 col-sm-5 col-xs-12 da-margin-top-30">
				<div class="da-step-container da-text-align-right da-left-animated-block">
					<p class="da-step-title da-font-montserrat"><span class="da-num-mobile da-red-text da-padding-right-15">01</span>Game Editor<span class="da-num-screen da-red-text da-padding-left-15">01</span></p>
					<p>Logical problems and puzzles. No physical effort. Only wit and observation. Everything is in your head.</p>
				</div>
			</div>
			<div class="col-md-5 col-md-offset-2 col-sm-5 col-sm-offset-2 col-xs-12 da-margin-top-30 da-right-animated-block">
				<div class="da-step-container">
					<p class="da-step-title da-font-montserrat"><span class="da-red-text da-padding-right-15">02</span>
					<a href="/escape/waitingRoom?num=1&nickname=${loginUser.nickname}">Game Room List</a></p>
					<p>Exactly 1 hour to find a way out and get out of the quest of the room, thinking all the fun and interesting puzzles on your heroic journey.</p>
				</div>
			</div>
		</div>
		<div class="row da-game-row">
			<div class="col-md-5 col-sm-5 col-xs-12 da-margin-top-30">
				<div class="da-step-container da-text-align-right da-left-animated-block">
					<p class="da-step-title da-font-montserrat">
					<a href="#" onclick="fnMove()">The Lastest Record</a><span class="da-num-screen da-red-text da-padding-left-15">03</span></p>
					<p>For the whole family and for your friends ! Your team - the key to a successful passing game. Trust and partner nayditie output.</p>
				</div>
			</div>
			<div class="col-md-5 col-md-offset-2 col-sm-5 col-sm-offset-2 col-xs-12 da-margin-top-30 da-right-animated-block">
				<div class="da-step-container">
					<p class="da-step-title da-font-montserrat"><span class="da-red-text da-padding-right-15">04</span>Make Game Room</p>
					<p>This is an unforgettable adventure in the exciting world of mystery. Only positive emotions and vivid feeling for the entire company.</p>
				</div>
			</div>
		</div>
		<div class="da-positioned-block">
			<img src="resources/images/${loginUser.profile}.png" id="loginProfile" alt="Key">
			<p align="center" id="loginId">${loginUser.id}</p>
			<p align="center" id="loginNickname">${loginUser.nickname}</p><br/><br/><br/><br/><br/><br/>
		</div>
	</div>
  	</div> 	
  	
  	
  	
	<div class="da-bg-container da-padding-bottom-90 background-image" data-image="img/blog-img-bg.png" id="Record">
		<!-- <div class="da-filter"></div> -->
		<div class="container">
			<h2 class="da-underline-title da-white-text">Latest Game</h2>
			<div class="row da-margin-top-30 da-text-news">
				<div class="col-sm-4 col-xs-12">
					<div class="da-margin-bottom-30 da-post-pic">
						<img src="resources/image/kuma.png" alt="new">
					</div>
					<div class="da-title-block">
						<div class="da-date-container br-container-date da-text-align-center da-font-montserrat">
							<p> <span class="da-font-big">23</span> oct</p>
						</div>
						<p class="da-blog-title da-margin-left-20pr"><a href="#">Game Map Name</a></p>
					</div>
					<p class="da-margin-top-30 da-gray-text">Explanation about the Game Map</p>
					<div class="da-margin-top-30 da-details-container">
						<a href="#" class="da-gray-text"><i class="fa fa-user"></i>Game Maker</a>
						<a href="#" class="da-gray-text"><i class="fa fa-folder-open"></i>Theme</a>
						<a href="#" class="da-gray-text"><i class="fa fa-comments"></i>80</a>
						<a href="#" class="da-gray-text"><i class="fa fa-eye"></i>456</a>
					</div>
				</div>
				<div class="col-sm-4 col-xs-12">
					<div class="da-margin-bottom-30  da-post-pic">
						<img src="resources/image/kuma.png" alt="new">
					</div>
					<div class="da-title-block">
						<div class="da-date-container br-container-date da-text-align-center da-font-montserrat">
							<p> <span class="da-font-big">21</span> oct</p>
						</div>
						<p class="da-blog-title da-margin-left-20pr"><a href="#">Game Map Name</a></p>
					</div>
					<p class="da-margin-top-30 da-gray-text">Explanation about the Game Map</p>
					<div class="da-margin-top-30 da-details-container">
						<a href="#" class="da-gray-text"><i class="fa fa-user"></i>Game Maker</a>
						<a href="#" class="da-gray-text"><i class="fa fa-folder-open"></i>Theme</a>
						<a href="#" class="da-gray-text"><i class="fa fa-comments"></i>80</a>
						<a href="#" class="da-gray-text"><i class="fa fa-eye"></i>456</a>
					</div>
				</div>
				<div class="col-sm-4 col-xs-12">
					<div class="da-margin-bottom-30 da-post-pic">
						<img src="resources/image/kuma.png" alt="new">
					</div>
					<div class="da-title-block">
						<div class="da-date-container br-container-date da-text-align-center da-font-montserrat">
							<p> <span class="da-font-big">17</span> oct</p>
						</div>
						<p class="da-blog-title da-margin-left-20pr"><a href="#">Game Map Name</a></p>
					</div>
					<p class="da-margin-top-30 da-gray-text">Explanation about the Game Map</p>
					<div class="da-margin-top-30 da-details-container">
						<a href="#" class="da-gray-text"><i class="fa fa-user"></i>Game Maker</a>
						<a href="#" class="da-gray-text"><i class="fa fa-folder-open"></i>Theme</a>
						<a href="#" class="da-gray-text"><i class="fa fa-comments"></i>80</a>
						<a href="#" class="da-gray-text"><i class="fa fa-eye"></i>456</a>
					</div>
				</div>
			</div>
			<!-- <div class="row da-margin-top-75">
				<div class="col-xs-12 da-text-align-center">
					<a href="#" class="da-btn da-btn-news hvr-sweep-to-right">all posts</a>
				</div>
			</div> -->
		</div>
	</div>
  	
	<footer>
		<div class="container">
			<div class="row da-footer-section">
				<div class="col-sm-3">
					<div class="da-footer-logo-container">
						<a href="home-1.html">
							<img src="img/logo.png" alt="Escape Room" class="img-responsive">
						</a>
					</div>
					<p class="da-margin-top-30">Curabitur iaculis accumsan augue, nec finibus mauris pretium eu. Duis placerat ex gravida nibh tristique porta. Nulla facilisi. Suspendisse ultricies eros blandit. Fusce aliquet quam eget neque ultrices elementum.</p>
				</div>
				<div class="col-sm-3 da-footer-contact">
					<p class="da-font-montserrat da-white-text">Contact</p>
					<a class="da-margin-top-30" href="#"><i class="fa fa-map-marker"></i>641 Dowd Avenue Elizabeth, NJ 07201</a>
					<a class="da-margin-top-20" href="mailto:contact@escaperoom.com"><i class="fa fa-envelope"></i>contact@escaperoom.com</a>
					<a class="da-margin-top-20" href="tel:18002009000"><i class="fa fa-phone"></i>1 800 200 9000</a>
				</div>
				<div class="col-sm-3">
					<p class="da-font-montserrat da-white-text">Subscribe</p>
					<p class="da-margin-top-30">Mauris non laoreet dui. Morbi lacus massa, euismod ut turpis molestie</p>
					<form class="da-form-container da-margin-top-15">
						<input class="da-padding-left-15" type="text" placeholder="Your email">
						<button>+</button>
					</form>
					<p class="da-margin-top-15">* Integer sit amet mi id sapien tempor</p>
				</div>
				<div class="col-sm-3">
					<p class="da-font-montserrat da-white-text">Some Photos</p>
					<div class="row da-margin-top-30">
						<div class="col-xs-4 da-footer-photo">
							<img class="img-responsive" src="img/footer-photo1.jpg" alt="Photo">
							<div class="da-photo-hover"></div>
						</div>
						<div class="col-xs-4 da-footer-photo">
						    <img class="img-responsive" src="img/footer-photo2.jpg" alt="Photo">
							<div class="da-photo-hover"></div>
						</div>
						<div class="col-xs-4 da-footer-photo">
							<img class="img-responsive" src="img/footer-photo3.jpg" alt="Photo">
							<div class="da-photo-hover"></div>
						</div>
					</div>
					<div class="row da-margin-top-15">
						<div class="col-xs-4 da-footer-photo">
							<img class="img-responsive" src="img/footer-photo4.jpg" alt="Photo">
							<div class="da-photo-hover"></div>
						</div>
						<div class="col-xs-4 da-footer-photo">
						    <img class="img-responsive" src="img/footer-photo5.jpg" alt="Photo">
							<div class="da-photo-hover"></div>
						</div>
						<div class="col-xs-4 da-footer-photo">
							<img class="img-responsive" src="img/footer-photo6.jpg" alt="Photo">
							<div class="da-photo-hover"></div>
						</div>
					</div>
				</div>
			</div>
			<hr class="line-btn">
			<div class="row da-padding-bottom-30">
				<div class="col-md-3 col-sm-3 da-margin-top-30 da-footer-copy">
					<p>&copy; 2016. All Rights Reserved.</p>
				</div>
				<div class="col-md-3 col-md-offset-6 col-sm-4 col-sm-offset-5 da-margin-top-20 da-padding-0 da-footer-social-container">
					<div class="da-footer-social clearfix">
						<a href="#"><i class="fa fa-facebook"></i></a>
						<a href="#"><i class="fa fa-twitter"></i></a>
						<a href="#"><i class="fa fa-google-plus"></i></a>
						<a href="#"><i class="fa fa-pinterest-p"></i></a>
						<a href="#"><i class="fa fa-tripadvisor"></i></a>
					</div>
				</div>
			</div>
		</div>
		<div class="da-btn-up">
			<i class="fa fa-angle-up" aria-hidden="true"></i>
			<p>Top</p>
		</div>
	</footer>
	
<%-- <div id="feature" align="center">
<table>
<tr>
	<td align="center">
	<span id="profile"><img src="resources/images/${loginUser.profile}.png"></span>
		<p>${loginUser.id}</p>
		<p>${loginUser.nickname}</p>
		<a href="#" class="btn btn-primary btn-xl" onclick="updateForm()">회원정보 수정</a>
		<a href="#" class="btn btn-primary btn-xl" onclick="logout()">로그아웃</a>
	</td>
	<td>
	<table>
		<tr>
		<td><span class="enter_btn"><button class="btn" id="editor_btn" style="vertical-align:middle"><span>editor</span></button><br /></span></td>
		</tr>
		<tr>
		<td><span class="enter_btn"><button class="btn" id="List_btn" style="vertical-align:middle"><span>Room List</span></button>
		<button class="btn" id="Make_btn" style="vertical-align:middle"><span>Make Room</span></button></span></td>
		</tr>
	</table>
	</td>
</tr>
</table>
	<div id="record_board">
		<a href="/escape/waitingRoom?num=1&nickname=${loginUser.nickname}"><img data-lazy="resources/image/kuma.png" class="record"/></a>
		<img data-lazy='resources/image/kuma.png'>
		<img data-lazy="resources/image/kuma.png" class="record">
		<img data-lazy="resources/image/kuma.png" class="record">
	</div>
</div> --%>

</body>
</html>
