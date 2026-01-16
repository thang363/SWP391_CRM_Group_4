<%-- scripts.jsp - JavaScript imports dùng chung --%>

    <!-- Ẩn spinner ngay lập tức (không phụ thuộc jQuery) -->
    <script>
        (function () {
            var spinner = document.getElementById('spinner');
            if (spinner) {
                spinner.classList.remove('show');
            }
        })();
    </script>

    <!-- JavaScript Libraries -->
    <script src="${pageContext.request.contextPath}/lib/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/chart/chart.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/easing/easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/waypoints/waypoints.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/tempusdominus/js/moment.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/tempusdominus/js/moment-timezone.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

    <!-- Template Javascript -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>