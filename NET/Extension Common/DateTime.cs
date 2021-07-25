// Get Firt day of week
 public DateTime firstDayOfWeek()
        {
            var today = (int)DateTime.Now.DayOfWeek;
            return DateTime.Now.AddDays(-(a - 1));
        }
        
// get start end day of Quarters, current week,  current month
public void date()
        {

            int dayOfWeek = (int)DateTime.Now.DayOfWeek;
            var firstDayOfWeek = DateTime.Now.AddDays(-(dayOfWeek - 1));
            int year = DateTime.Now.Year;
            int month = DateTime.Now.Year;
            // this week 
            var startWeek = firstDayOfWeek.ToString("dd/MM/yyyy");
            var endWeek = firstDayOfWeek.AddDays(6).ToString("dd/MM/yyyy");
            // this month 
            var startMonth = new DateTime(year,month,1);
            var endMonth = new DateTime(year, month, DateTime.DaysInMonth(year, month));
            // 1st Quarter
            var start1st= new DateTime(year, 1, 1);
            var end1st = new DateTime(year, 3, DateTime.DaysInMonth(year, 3);
            // 2st Quarter
            var start2st = new DateTime(year, 4, 1);
            var end2st = new DateTime(year, 6, DateTime.DaysInMonth(year, 6));
            // 3st Quarter
            var start3st = new DateTime(year, 7, 1);
            var end3st = new DateTime(year, 9, DateTime.DaysInMonth(year, 9));
            // 4st Quarter
            var start4st = new DateTime(year, 10, 1);
            var end4st = new DateTime(year, 12, DateTime.DaysInMonth(year, 12));


         
        }
public string TimeAgo(DateTime yourDate)
{
const int SECOND = 1;
const int MINUTE = 60 * SECOND;
const int HOUR = 60 * MINUTE;
const int DAY = 24 * HOUR;
const int MONTH = 30 * DAY;

var ts = new TimeSpan(DateTime.UtcNow.Ticks - yourDate.Ticks);
double delta = Math.Abs(ts.TotalSeconds);

if (delta < 1 * MINUTE)
 return ts.Seconds == 1 ? "1 giây trước " : ts.Seconds + “ giây trước";

if (delta < 2 * MINUTE)
 return "1 phút trước"”"; 

if (delta < 45 * MINUTE)
  return ts.Minutes + " phút trước”";

if (delta < 90 * MINUTE)
 return "1 giờ trước";

if (delta < 24 * HOUR)
  return ts.Hours + " giờ trước";

if (delta < 48 * HOUR)
 return "hôm qua"

if (delta < 30 * DAY)
 return ts.Days + " ngày trướ";

if (delta < 12 * MONTH)
{
  int months = Convert.ToInt32(Math.Floor((double)ts.Days / 30));
  return months <= 1 ? "1 tháng trước" : months + " tháng trước";
}
else
{
  int years = Convert.ToInt32(Math.Floor((double)ts.Days / 365));
 return years <= 1 ? "1 năm trước" : years + "năm trước";
}
}