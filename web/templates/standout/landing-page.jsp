<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html class="no-js" lang="vi">

        <head>

            <!--- basic page needs
    ================================================== -->
            <meta charset="utf-8">
            <title>${pageTitle != null ? pageTitle : 'Standout'}</title>
            <meta name="description" content="">
            <meta name="author" content="">

            <!-- mobile specific metas
    ================================================== -->
            <meta name="viewport" content="width=device-width, initial-scale=1">

            <!-- CSS
    ================================================== -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/standout/css/base.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/standout/css/vendor.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/templates/standout/css/main.css">

            <!-- script
    ================================================== -->
            <script src="${pageContext.request.contextPath}/templates/standout/js/modernizr.js"></script>
            <script src="${pageContext.request.contextPath}/templates/standout/js/pace.min.js"></script>

            <!-- favicons
    ================================================== -->
            <link rel="shortcut icon" href="${pageContext.request.contextPath}/templates/standout/favicon.ico"
                type="image/x-icon">
            <link rel="icon" href="${pageContext.request.contextPath}/templates/standout/favicon.ico"
                type="image/x-icon">

        </head>

        <body id="top">

            <div id="preloader">
                <div id="loader"></div>
            </div>


            <!-- header 
    ================================================== -->
            <header class="s-header">

                <div class="header-logo">
                    <a class="site-logo" href="#home">
                        <img src="${pageContext.request.contextPath}/templates/standout/images/logo.svg" alt="Homepage">
                    </a>
                </div>

                <nav class="row header-nav-wrap wide">
                    <ul class="header-main-nav">
                        <li class="current"><a class="smoothscroll" href="#home" title="intro">Intro</a></li>
                        <li><a class="smoothscroll" href="#about" title="about">About</a></li>
                        <li><a class="smoothscroll" href="#features" title="features">Features</a></li>
                        <li><a class="smoothscroll" href="#pricing" title="pricing">Pricing</a></li>
                        <li><a href="#contact" title="blog">Blog</a></li>
                    </ul>

                    <ul class="header-social">
                        <li><a href="#0"><i class="fab fa-facebook-f" aria-hidden="true"></i></a></li>
                        <li><a href="#0"><i class="fab fa-twitter" aria-hidden="true"></i></a></li>
                        <li><a href="#0"><i class="fab fa-instagram" aria-hidden="true"></i></a></li>
                    </ul>
                </nav>

                <a class="header-menu-toggle" href="#"><span>Menu</span></a>

            </header> <!-- end header -->


            <!-- home
    ================================================== -->
            <section id="home" class="s-home target-section">

                <div class="home-image-part"></div>

                <div class="home-content">

                    <div class="row home-content__main wide">

                        <h1>
                            ${heroTitle != null ? heroTitle : "Standout App"}
                        </h1>

                        <h3>
                            ${heroDesc != null ? heroDesc : "An Amazing App That Does It All."}
                        </h3>

                        <div class="home-content__button">
                            <a class="btn-video"
                                href="https://player.vimeo.com/video/14592941?color=00a650&title=0&byline=0&portrait=0"
                                data-lity>
                                <span class="video-icon"></span>
                            </a>
                            <a href="#contact" class="smoothscroll btn btn--primary btn--large">
                                Start Free Trial
                            </a>
                        </div>

                    </div> <!-- end home-content__main -->

                    <a href="#about" class="home-scroll smoothscroll">
                        <span class="home-scroll__text">Scroll Down</span>
                        <span class="home-scroll__icon"></span>
                    </a>

                </div> <!-- end home-content -->

            </section> <!-- end s-home -->


            <!-- about
    ================================================== -->
            <section id="about" class="s-about target-section">

                <div class="row section-header narrower align-center" data-aos="fade-up">
                    <div class="col-full">
                        <h1 class="display-1">
                            ${aboutTitle != null ? aboutTitle : 'The #1 Marketing CRM Platform.'}
                        </h1>
                        <p class="lead">
                            ${aboutDesc != null ? aboutDesc : 'Manage campaigns, track leads, and automate your
                            marketing
                            workflow in one place. Powerful, secure, and easy to use.'}
                        </p>
                    </div>
                </div> <!-- end section-header -->

                <div class="row about-desc" data-aos="fade-up">
                    <div class="col-full slick-slider about-desc__slider">

                        <div class="about-desc__slide">
                            <h3 class="item-title">Smart.</h3>

                            <p>
                                Et nihil atque ex. Reiciendis et rerum ut voluptate. Omnis molestiae nemo est.
                                Ut quis enim rerum quia assumenda repudiandae non cumque qui. Amet repellat
                                omnis ea aut cumque eos.
                            </p>
                        </div> <!-- end about-desc__slide -->

                        <div class="about-desc__slide">
                            <h3 class="item-title">User-Friendly.</h3>

                            <p>
                                Et nihil atque ex. Reiciendis et rerum ut voluptate. Omnis molestiae nemo est.
                                Ut quis enim rerum quia assumenda repudiandae non cumque qui. Amet repellat
                                omnis ea aut cumque eos.
                            </p>
                        </div> <!-- end about-desc__slide -->

                        <div class="about-desc__slide">
                            <h3 class="item-title">Powerful.</h3>

                            <p>
                                Et nihil atque ex. Reiciendis et rerum ut voluptate. Omnis molestiae nemo est.
                                Ut quis enim rerum quia assumenda repudiandae non cumque qui. Amet repellat
                                omnis ea aut cumque eos.
                            </p>
                        </div> <!-- end about-desc__slide -->

                        <div class="about-desc__slide">
                            <h3 class="item-title">Secure.</h3>

                            <p>
                                Et nihil atque ex. Reiciendis et rerum ut voluptate. Omnis molestiae nemo est.
                                Ut quis enim rerum quia assumenda repudiandae non cumque qui. Amet repellat
                                omnis ea aut cumque eos.
                            </p>
                        </div> <!-- end about-desc__slide -->

                    </div> <!-- end about-desc__slider -->
                </div> <!-- end about-desc -->

                <div class="row about-bottom-image" data-aos="fade-up">
                    <img src="${pageContext.request.contextPath}/templates/standout/images/app-screen-1400.png" srcset="${pageContext.request.contextPath}/templates/standout/images/app-screen-600.png 600w, 
                         ${pageContext.request.contextPath}/templates/standout/images/app-screen-1400.png 1400w, 
                         ${pageContext.request.contextPath}/templates/standout/images/app-screen-2800.png 2800w"
                        sizes="(max-width: 2800px) 100vw, 2800px" alt="App Screenshots">
                </div>

            </section> <!-- end s-about -->


            <!-- process
    ================================================== -->
            <section id="process" class="s-process">

                <div class="row">
                    <div class="col-full text-center" data-aos="fade-up">
                        <h2 class="display-2">How The App Works?</h2>
                    </div>
                </div>

                <div class="row process block-1-4 block-m-1-2 block-tab-full">
                    <div class="col-block item-process" data-aos="fade-up">
                        <div class="item-process__text">
                            <h3>Register</h3>
                            <p>
                                Sign up for an account and configure your organization settings. Simple and fast setup.
                            </p>
                        </div>
                    </div>
                    <div class="col-block item-process" data-aos="fade-up">
                        <div class="item-process__text">
                            <h3>Setup Campaign</h3>
                            <p>
                                Create marketing campaigns, define audiences, and set your budget and goals.
                            </p>
                        </div>
                    </div>
                    <div class="col-block item-process" data-aos="fade-up">
                        <div class="item-process__text">
                            <h3>Launch</h3>
                            <p>
                                Publish your landing pages and ads. Reach your target customers instantly.
                            </p>
                        </div>
                    </div>
                    <div class="col-block item-process" data-aos="fade-up">
                        <div class="item-process__text">
                            <h3>Track & Analyze</h3>
                            <p>
                                Monitor real-time performance, track leads, and optimize ROI with detailed analytics.
                            </p>
                        </div>
                    </div>
                </div> <!-- end process -->

                <div class="row process-bottom-image" data-aos="fade-up">
                    <img src="${pageContext.request.contextPath}/templates/standout/images/phone-app-screens-1000.png"
                        srcset="${pageContext.request.contextPath}/templates/standout/images/phone-app-screens-600.png 600w, 
                         ${pageContext.request.contextPath}/templates/standout/images/phone-app-screens-1000.png 1000w, 
                         ${pageContext.request.contextPath}/templates/standout/images/phone-app-screens-2000.png 2000w"
                        sizes="(max-width: 2000px) 100vw, 2000px" alt="App Screenshots">
                </div>

            </section> <!-- end s-process -->


            <!-- features
    ================================================== -->
            <section id="features" class="s-features target-section">

                <div class="row section-header narrower align-center has-bottom-sep" data-aos="fade-up">
                    <div class="col-full">
                        <h1 class="display-1">
                            Loaded With Features You Would Surely Love.
                        </h1>
                        <p class="lead">
                            Et nihil atque ex. Reiciendis et rerum ut voluptate. Omnis molestiae nemo est.
                            Ut quis enim rerum quia assumenda repudiandae non cumque qui. Amet repellat
                            omnis ea.
                        </p>
                    </div>
                </div> <!-- end section-header -->

                <div class="row bit-narrow features block-1-2 block-mob-full">

                    <div class="col-block item-feature" data-aos="fade-up">
                        <div class="item-feature__icon">
                            <i class="icon-upload"></i>
                        </div>
                        <div class="item-feature__text">
                            <h3 class="item-title">${featureTitle1 != null ? featureTitle1 : 'Cloud Data'}</h3>
                            <p>${featureDesc1 != null ? featureDesc1 : 'Access your campaign data from anywhere. Secure
                                cloud storage ensures you never lose a lead.'}
                            </p>
                        </div>
                    </div>

                    <div class="col-block item-feature" data-aos="fade-up">
                        <div class="item-feature__icon">
                            <i class="icon-video-camera"></i>
                        </div>
                        <div class="item-feature__text">
                            <h3 class="item-title">${featureTitle2 != null ? featureTitle2 : 'Real-time Analytics'}</h3>
                            <p>${featureDesc2 != null ? featureDesc2 : 'Watch your campaign performance live. Visual
                                cues
                                and charts help you make data-driven decisions.'}
                            </p>
                        </div>
                    </div>

                    <div class="col-block item-feature" data-aos="fade-up">
                        <div class="item-feature__icon">
                            <i class="icon-shield"></i>
                        </div>
                        <div class="item-feature__text">
                            <h3 class="item-title">${featureTitle3 != null ? featureTitle3 : 'Always Secure'}</h3>
                            <p>${featureDesc3 != null ? featureDesc3 : 'Nemo cupiditate ab quibusdam quaerat impedit
                                magni.
                                Earum suscipit ipsum laudantium.'}
                            </p>
                        </div>
                    </div>

                    <div class="col-block item-feature" data-aos="fade-up">
                        <div class="item-feature__icon">
                            <i class="icon-lego-block"></i>
                        </div>
                        <div class="item-feature__text">
                            <h3 class="item-title">Easy Integration</h3>
                            <p>seamlessly integrate with your existing tools and workflows. API support included.
                            </p>
                        </div>
                    </div>



                </div> <!-- end features -->

                <div class="testimonials-wrap" data-aos="fade-up">

                    <div class="row">
                        <div class="col-full testimonials-header">
                            <h2 class="display-2">1 Million+ Users Can't Be Wrong.</h2>
                        </div>
                    </div>

                    <div class="row testimonials">

                        <div class="col-full slick-slider testimonials__slider">

                            <div class="testimonials__slide">
                                <img src="${pageContext.request.contextPath}/templates/standout/images/avatars/user-01.jpg"
                                    alt="Author image" class="testimonials__avatar">
                                <div class="testimonials__author">
                                    <span class="testimonials__name">John Doe</span>
                                    <a href="#0" class="testimonials__link">CEO, TechCorp</a>
                                </div>
                                <p>This CRM transformed how we handle leads. Highly recommended!</p>
                            </div> <!-- end testimonials__slide -->

                            <div class="testimonials__slide">
                                <img src="${pageContext.request.contextPath}/templates/standout/images/avatars/user-02.jpg"
                                    alt="Author image" class="testimonials__avatar">
                                <div class="testimonials__author">
                                    <span class="testimonials__name">Jane Smith</span>
                                    <a href="#0" class="testimonials__link">Marketing Director, BrandX</a>
                                </div>
                                <p>The analytics features are game-changing. We saw a 20% increase in conversion.</p>
                            </div> <!-- end testimonials__slide -->

                            <div class="testimonials__slide">
                                <img src="${pageContext.request.contextPath}/templates/standout/images/avatars/user-03.jpg"
                                    alt="Author image" class="testimonials__avatar">
                                <div class="testimonials__author">
                                    <span class="testimonials__name">Michael Brown</span>
                                    <a href="#0" class="testimonials__link">Sales Manager, GlobalSolutions</a>
                                </div>
                                <p>Intuitive interface and powerful automation tools. A must-have for any sales team.
                                </p>
                            </div> <!-- end testimonials__slide -->

                        </div> <!-- end testimonials__slider -->

                    </div> <!-- end testimonials -->

                </div> <!-- end testimonials-wrap -->

            </section> <!-- end s-features -->


            <!-- pricing
    ================================================== -->
            <section id="pricing" class="s-pricing target-section">

                <div class="row section-header narrower align-center" data-aos="fade-up">
                    <div class="col-full">
                        <h1 class="display-1">
                            Our Easy Pricing Plans For Everyone.
                        </h1>
                        <p class="lead">
                            Et nihil atque ex. Reiciendis et rerum ut voluptate. Omnis molestiae nemo est.
                            Ut quis enim rerum quia assumenda repudiandae non cumque qui. Amet repellat
                            omnis ea.
                        </p>
                    </div>
                </div> <!-- end section-header -->

                <div class="row plans block-1-3 block-m-1-2 block-tab-full stack">

                    <div class="col-block item-plan" data-aos="fade-up">
                        <div class="item-plan__block">

                            <div class="item-plan__top-part">
                                <h3 class="item-plan__title">Basic</h3>
                                <p class="item-plan__price">Free</p>
                            </div>

                            <div class="item-plan__bottom-part">
                                <ul class="item-plan__features disc">
                                    <li><span>5GB</span> Storage</li>
                                    <li><span>10GB</span> Bandwidth</li>
                                    <li><span>5</span> Databases</li>
                                    <li><span>30</span> Email Accounts</li>
                                </ul>

                                <a class="btn btn--primary large full-width" href="#0">Get Started</a>
                            </div>

                        </div>
                    </div> <!-- end item-plan -->

                    <div class="col-block item-plan item-plan--popular" data-aos="fade-up">
                        <div class="item-plan__block">

                            <div class="item-plan__top-part">
                                <h3 class="item-plan__title">Pro Plan</h3>
                                <p class="item-plan__price">$10</p>
                                <p class="item-plan__per">Per Month</p>
                            </div>

                            <div class="item-plan__bottom-part">
                                <ul class="item-plan__features disc">
                                    <li><span>500GB</span> Storage</li>
                                    <li><span>Unlimited</span> Bandwidth</li>
                                    <li><span>50</span> Databases</li>
                                    <li><span>50</span> Email Accounts</li>
                                </ul>

                                <a class="btn btn--primary large full-width" href="#0">Get Started</a>
                            </div>

                        </div>
                    </div> <!-- end item-plan -->

                    <div class="col-block item-plan" data-aos="fade-up">
                        <div class="item-plan__block">

                            <div class="item-plan__top-part">
                                <h3 class="item-plan__title">Ultimate Plan</h3>
                                <p class="item-plan__price">$20</p>
                                <p class="item-plan__per">Per Month</p>
                            </div>

                            <div class="item-plan__bottom-part">
                                <ul class="item-plan__features disc">
                                    <li><span>1TB</span> Storage</li>
                                    <li><span>Unlimited</span> Bandwidth</li>
                                    <li><span>100</span> Databases</li>
                                    <li><span>100</span> Email Accounts</li>
                                </ul>

                                <a class="btn btn--primary large full-width" href="#0">Get Started</a>
                            </div>

                        </div>
                    </div> <!-- end item-plan -->

                </div> <!-- end plans -->

            </section> <!-- end s-pricing -->


            <!-- download
    ================================================== -->
            <section id="download" class="s-download">

                <div class="row download-content">
                    <div class="col-six md-seven download-content__text pull-right" data-aos="fade-up">
                        <h1 class="display-2">
                            Start Your Free Trial Today!
                        </h1>
                        <p>
                            Experience the power of our Marketing CRM. No credit card required.
                        </p>
                        <ul class="download-content__badges">
                            <li><a href="#contact" class="btn btn--primary btn--large" style="margin-top: 0;">Register
                                    Now</a></li>
                        </ul>
                    </div>
                    <div class="download-content__image" data-aos="fade-up">
                        <img src="${pageContext.request.contextPath}/templates/standout/images/phone-app-profile-550.png"
                            srcset="${pageContext.request.contextPath}/templates/standout/images/phone-app-profile-550.png 1x, ${pageContext.request.contextPath}/templates/standout/images/phone-app-profile-1100.png 2x">
                    </div>
                </div>

            </section> <!-- end s-download -->


            <!-- contact
    ================================================== -->
            <section id="contact" class="s-pricing target-section">

                <div class="row section-header narrower align-center" data-aos="fade-up">
                    <div class="col-full">
                        <h1 class="display-1">
                            Get In Touch With Us
                        </h1>
                        <p class="lead">
                            Have questions? We'd love to hear from you. Send us a message and we'll respond as soon as
                            possible.
                        </p>
                    </div>
                </div> <!-- end section-header -->

                <div class="row" data-aos="fade-up">
                    <div class="col-full">

                        <!-- Contact Form -->
                        <c:choose>
                            <c:when
                                test="${campaignStatus == 'Paused' || campaignStatus == 'Finished' || campaignStatus == 'Cancelled'}">
                                <div class="alert alert-warning"
                                    style="text-align: center; padding: 30px; background-color: #f3f4f6; border: 1px solid #e5e7eb; border-radius: 8px; margin-top: 30px;">
                                    <h3 style="color: #4b5563; margin-bottom: 10px;">Chiến dịch đã khép lại</h3>
                                    <p style="color: #6b7280; font-size: 1.6rem; margin-bottom: 0;">Cảm ơn bạn đã quan
                                        tâm! Chiến dịch này hiện đã kết thúc hoặc đang tạm dừng, không thể nhận thêm
                                        đăng ký.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <form id="contactForm" method="POST"
                                    action="${pageContext.request.contextPath}/lp/submit" class="contact-form">
                                    <input type="hidden" name="landingPageId" value="${landingPageId}">

                                    <div class="form-field">
                                        <input name="fullName" type="text" id="contactName" placeholder="Your Name *"
                                            required>
                                    </div>

                                    <div class="form-field">
                                        <input name="email" type="email" id="contactEmail" placeholder="Your Email *"
                                            required>
                                    </div>

                                    <div class="form-field">
                                        <input name="phone" type="tel" id="contactPhone" placeholder="Your Phone">
                                    </div>

                                    <div class="form-field">
                                        <textarea name="message" id="contactMessage" placeholder="Your Message" rows="6"
                                            maxlength="1000"></textarea>
                                        <div id="charCount"
                                            style="text-align: right; font-size: 1.2rem; margin-top: -3rem; margin-bottom: 3rem; color: rgba(0, 0, 0, 0.5);">
                                            0/1000</div>
                                    </div>

                                    <div class="form-field">
                                        <button type="submit" class="btn btn--primary large full-width">Send
                                            Message</button>
                                    </div>

                                    <div class="message-warning" style="display: none;">
                                        Something went wrong. Please try again.
                                    </div>

                                    <div class="message-success" style="display: none;">
                                        Your message was sent, thank you!<br>We'll get back to you soon.
                                    </div>
                                </form>
                            </c:otherwise>
                        </c:choose>

                    </div>
                </div>

            </section> <!-- end s-contact -->


            <!-- footer
    ================================================== -->
            <footer class="s-footer footer">

                <div class="row footer__top">
                    <div class="col-six md-full">
                        <h1 class="display-2">
                            Let's Stay In Touch.
                        </h1>
                        <p class="lead">
                            Subscribe for updates, special offers and more.
                        </p>
                    </div>
                    <div class="col-six md-full footer__subscribe end">
                        <div class="subscribe-form">
                            <form id="mc-form" class="group" novalidate="true">

                                <input type="email" value="" name="EMAIL" class="email" id="mc-email"
                                    placeholder="Email Address" required="">

                                <input type="submit" name="subscribe" value="Sign Up">

                                <label for="mc-email" class="subscribe-message"></label>

                            </form>
                        </div>
                    </div>
                </div>

                <div class="row footer__bottom">
                    <div class="col-five tab-full">
                        <div class="footer__logo">
                            <a href="#home">
                                <img src="${pageContext.request.contextPath}/templates/standout/images/logo.svg"
                                    alt="Homepage">
                            </a>
                        </div>

                        <p>
                            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed
                            do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                            Ut enim ad minim veniam, quis nostrud exercitation ullamco
                            laboris nisi ut aliquip ex ea commodo consequat.
                        </p>

                        <ul class="footer__social">
                            <li><a href="#0"><i class="fab fa-facebook-f" aria-hidden="true"></i></a></li>
                            <li><a href="#0"><i class="fab fa-twitter" aria-hidden="true"></i></a></li>
                            <li><a href="#0"><i class="fab fa-instagram" aria-hidden="true"></i></a></li>
                        </ul>
                    </div>

                    <div class="col-six tab-full end">
                        <ul class="footer__site-links">
                            <li><a class="smoothscroll" href="#home" title="intro">Intro</a></li>
                            <li><a class="smoothscroll" href="#about" title="about">About</a></li>
                            <li><a class="smoothscroll" href="#features" title="features">Features</a></li>
                            <li><a class="smoothscroll" href="#pricing" title="pricing">Pricing</a></li>
                            <li><a href="#contact" title="blog">Blog</a></li>
                        </ul>

                        <p class="footer__contact">
                            Do you have a question? Send us a word: <br>
                            <a href="mailto:#0" class="footer__mail-link">support@standout.com</a>
                        </p>

                        <div class="cl-copyright">
                            <span><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                                Copyright &copy;
                                <script>document.write(new Date().getFullYear());</script> All rights reserved | This
                                template
                                is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a
                                    href="https://colorlib.com" target="_blank">Colorlib</a>
                                <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                            </span>
                        </div>
                    </div>

                </div>

                <div class="go-top">
                    <a class="smoothscroll" title="Back to Top" href="#top"></a>
                </div>

            </footer> <!-- end s-footer -->


            <!-- Java Script
    ================================================== -->
            <script src="${pageContext.request.contextPath}/templates/standout/js/jquery-3.2.1.min.js"></script>
            <script src="${pageContext.request.contextPath}/templates/standout/js/plugins.js"></script>
            <script src="${pageContext.request.contextPath}/templates/standout/js/main.js"></script>

            <!-- Contact Form Handler -->
            <script>
                $(document).ready(function () {
                    // Character counter for message
                    $('#contactMessage').on('input', function () {
                        var currentLength = $(this).val().length;
                        $('#charCount').text(currentLength + '/1000');
                    });

                    $('#contactForm').on('submit', function (e) {
                        e.preventDefault();

                        var form = $(this);
                        var submitBtn = form.find('button[type="submit"]');
                        var messageWarning = form.find('.message-warning');
                        var messageSuccess = form.find('.message-success');

                        // Disable submit button
                        submitBtn.prop('disabled', true).text('Sending...');
                        messageWarning.hide();
                        messageSuccess.hide();

                        // --- Client-side Validation ---
                        var fullName = $('#contactName').val().trim();
                        var email = $('#contactEmail').val().trim();
                        var phone = $('#contactPhone').val().trim();
                        var message = $('#contactMessage').val().trim();

                        if (!fullName || !email) {
                            messageWarning.text('Vui lòng điền tên và email.').show();
                            submitBtn.prop('disabled', false).text('Send Message');
                            return;
                        }

                        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (!emailRegex.test(email)) {
                            messageWarning.text('Email không hợp lệ.').show();
                            submitBtn.prop('disabled', false).text('Send Message');
                            return;
                        }

                        if (phone) {
                            var phoneRegex = /^(0|84)(3|5|7|8|9)[0-9]{8}$/;
                            if (!phoneRegex.test(phone)) {
                                messageWarning.text('Số điện thoại không đúng định dạng VN (10 số).').show();
                                submitBtn.prop('disabled', false).text('Send Message');
                                return;
                            }
                        }

                        if (message.length > 1000) {
                            messageWarning.text('Tin nhắn quá dài (Tối đa 1000 ký tự).').show();
                            submitBtn.prop('disabled', false).text('Send Message');
                            return;
                        }
                        // -----------------------------

                        // Submit via AJAX
                        $.ajax({
                            type: 'POST',
                            url: form.attr('action'),
                            data: form.serialize(),
                            dataType: 'json',
                            success: function (response) {
                                if (response.success) {
                                    messageSuccess.show();
                                    form[0].reset(); // Clear form
                                } else {
                                    messageWarning.text(response.message || 'Something went wrong. Please try again.').show();
                                }
                            },
                            error: function () {
                                messageWarning.text('Network error. Please try again.').show();
                            },
                            complete: function () {
                                submitBtn.prop('disabled', false).text('Send Message');
                            }
                        });
                    });
                });
            </script>

        </body>