<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cảm ơn bạn - CRM System</title>
        <!-- Tailwind for quick premium look since it's a standalone page -->
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">
        <style>
            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
            }

            .gradient-bg {
                background: radial-gradient(circle at top right, #4f46e5, transparent),
                    radial-gradient(circle at bottom left, #ec4899, transparent);
            }
        </style>
    </head>

    <body class="bg-slate-900 text-white h-screen flex items-center justify-center overflow-hidden">
        <!-- Background Accents -->
        <div class="absolute inset-0 gradient-bg opacity-20 pointer-events-none"></div>
        <div
            class="absolute top-0 left-0 w-full h-full bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] opacity-10 pointer-events-none">
        </div>

        <div class="relative z-10 max-w-lg w-full p-8 text-center">
            <!-- Success Icon -->
            <div
                class="mb-8 inline-flex items-center justify-center w-24 h-24 rounded-full bg-indigo-500/20 border border-indigo-500/30 animate-bounce">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-indigo-400" fill="none"
                    viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
            </div>

            <h1 class="text-4xl font-bold mb-4 tracking-tight">Cảm ơn bạn!</h1>
            <p class="text-slate-400 text-lg mb-10 leading-relaxed">
                Chúng tôi đã ghi nhận sự quan tâm của bạn. Đội ngũ chuyên viên sẽ sớm liên hệ để tư vấn giải pháp phù
                hợp nhất cho bạn.
            </p>

            <div class="flex flex-col gap-4">
                <a href="https://yourwebsite.com"
                    class="px-8 py-3 bg-indigo-600 hover:bg-indigo-500 transition-all rounded-xl font-semibold shadow-lg shadow-indigo-500/25">
                    Về trang chủ
                </a>
                <p class="text-xs text-slate-500 italic mt-4">Trang này sẽ tự động đóng sau 10 giây...</p>
            </div>
        </div>

        <script>
            // Optional: Auto close or redirect
            setTimeout(() => {
                // window.location.href = 'https://yourwebsite.com';
            }, 10000);
        </script>
    </body>

    </html>