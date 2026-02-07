<%-- sales-pipeline.jsp - Trang Sales Pipeline --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Đặt biến currentPage để highlight menu active --%>
<% request.setAttribute("currentPage", "sales-pipeline" ); %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">

    <head>
        <title>Sales Pipeline - CRM System</title>
        <%@ include file="/includes/head.jsp" %>
        <style>
            .pipeline-column {
                min-height: 500px;
                background: #f8f9fa;
                border-radius: 10px;
                padding: 15px;
            }

            .pipeline-header {
                font-weight: 600;
                padding: 10px 15px;
                border-radius: 8px;
                margin-bottom: 15px;
                color: white;
            }

            .pipeline-header.lead {
                background: linear-gradient(135deg, #6c757d, #495057);
            }

            .pipeline-header.qualified {
                background: linear-gradient(135deg, #0d6efd, #0a58ca);
            }

            .pipeline-header.proposal {
                background: linear-gradient(135deg, #fd7e14, #dc6a12);
            }

            .pipeline-header.negotiation {
                background: linear-gradient(135deg, #6f42c1, #5a32a3);
            }

            .pipeline-header.closed {
                background: linear-gradient(135deg, #198754, #157347);
            }

            .deal-card {
                background: white;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 10px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                cursor: grab;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .deal-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .deal-card:active {
                cursor: grabbing;
            }

            .deal-value {
                font-size: 1.1rem;
                font-weight: 600;
                color: #198754;
            }

            .deal-company {
                font-weight: 500;
                color: #333;
            }

            .deal-contact {
                font-size: 0.85rem;
                color: #666;
            }

            .deal-date {
                font-size: 0.8rem;
                color: #999;
            }

            .stage-total {
                font-size: 0.9rem;
                opacity: 0.9;
            }
        </style>
    </head>

    <body>
        <div class="container-xxl position-relative bg-white d-flex p-0">
            <!-- Spinner Start -->
            <div id="spinner"
                 class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                    <span class="sr-only">Loading...</span>
                </div>
            </div>
            <!-- Spinner End -->

            <%-- Include Sidebar --%>
            <%@ include file="/includes/sidebar.jsp" %>

            <!-- Content Start -->
            <div class="content">
                <%-- Include Top Navbar --%>
                <%@ include file="/includes/topbar.jsp" %>

                <!-- Page Header -->
                <div class="container-fluid pt-4 px-4">
                    <div class="row g-4">
                        <div class="col-12">
                            <div
                                class="d-flex justify-content-between align-items-center mb-4">
                                <h3 class="mb-0"><i
                                        class="fa fa-funnel-dollar me-2"></i>Lead List
                                </h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container-fluid pt-4 px-4">
                    <div class="row g-4">
                        <div class="col-12">
                            <table border="1" cellpadding="8" cellspacing="0" width="100%">

                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Phone</th>
                                        <th>Status</th>
                                        <th>IsConverted</th>
                                        <th>Created At</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="lead" items="${leadList}">
                                        <tr>
                                            <td>${lead.id}</td>
                                            <td>${lead.fullName}</td>
                                            <td>${lead.email}</td>
                                            <td>${lead.phone}</td>
                                            <td>${lead.status}</td>
                                            <td><c:choose>
                                                    <c:when test="${lead.isConverted}">Yes</c:when>
                                                    <c:otherwise>No</c:otherwise>
                                                </c:choose></td>
                                            <td>${lead.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <%-- Include Footer --%>
                <%@ include file="/includes/footer.jsp" %>

            </div>
            <!-- Content End -->

            <!-- Back to Top -->
            <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                    class="bi bi-arrow-up"></i></a>
        </div>
        <!-- Add Deal Modal -->



        <%-- Include Scripts --%>
        <%@ include file="/includes/scripts.jsp" %>

        <!-- Inline script để đảm bảo ẩn spinner -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var spinner = document.getElementById('spinner');
                if (spinner) {
                    spinner.classList.remove('show');
                }
            });
        </script>
    </body>

</html>