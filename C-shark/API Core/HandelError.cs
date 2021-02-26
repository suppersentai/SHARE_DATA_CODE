
/*Attribute kiểm soát lỗi
        +  OnActionExecuting xử lí trước khi vào controller, nếu model state ko hợp lệ  thì trả về Định dạng ApiResponseModel (Mặc định sẽ throw 1 exception ko có cấu trúc)
        + Trong Startup.cs phải set  như dưới, nếu ko sẽ throw exception lỗi 500 trước khi chạy vào  OnActionExecuting
         services.Configure<ApiBehaviorOptions>(options =>
                {
                    options.SuppressModelStateInvalidFilter = true;
                });
     */
public class ValidModelState : ActionFilterAttribute
    {
        public ValidModelState()
        {
        }
        public override void OnActionExecuted(ActionExecutedContext context)
        {
            base.OnActionExecuted(context);
        }
        public override void OnActionExecuting(ActionExecutingContext actionContext)
        {
            base.OnActionExecuting(actionContext);
            var modelState = actionContext.ModelState;

            if (!modelState.IsValid)
            {
                var errors = modelState.Values
                    .SelectMany(v => v.Errors);
                var message = errors.Select(n => n.ErrorMessage).FirstOrDefault();
                ApiResponseModel apiResponse = new ApiResponseModel();
                apiResponse.Message = message;
                actionContext.Result =
                    new OkObjectResult(apiResponse);
            }
        }
    }


/*
Khi có exception trong controller, server sẽ throw 500 error
đế customer response (vẫn trả về 200 mà ko phải 500 ) trong Startup.cs/Configure thêm:
  app.UseExceptionHandler("/Error");

  vả 1 controller xử lí lỗi
*/
 [ApiController]
    [ApiExplorerSettings(IgnoreApi = true)]
    public class ExceptionController : ControllerBase
    {
        [Route("/error")]
        public async void Error()
        {
            //ApiResponseModel apiResponse = new ApiResponseModel();
            //var context = HttpContext.Features.Get<IExceptionHandlerFeature>();
            //var ex = context.Error; 
            //apiResponse.Message = ex.InnerException == null ? ex.Message : ex.InnerException.Message;

            //Response.StatusCode = 200;

            //return apiResponse ; // Your error model

        }
    }