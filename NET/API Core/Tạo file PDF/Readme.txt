Step 1: Tải về thư viện DinkToPdf
Step 2: Trong Startup.cs inject service

            // inject DrinkToPdf
            services.AddSingleton(typeof(IConverter), new SynchronizedConverter(new PdfTools()));
            // inject Service tự tạo
            services.AddTransient<IDocumentService, DocumentService>();
            services.AddTransient<IRazorRendererHelper, RazorRendererHelper>();

Step 3: Thêm 3 file thư viện vào project (Cùng cấp với Views,Controller folder)

Step 3: Cách sử dụng. 
Gọi hàm GeneratePdfFromRazorView hoặc GeneratePdfFromString trong DocumentServices