package scheduler;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Khi Tomcat start → tính delay đến 00:00 đêm → lên lịch chạy
 * AutomationJobRunner mỗi 24h.
 */
@WebListener
public class AutomationJobScheduler implements ServletContextListener {

    private static final Logger LOG = Logger.getLogger(AutomationJobScheduler.class.getName());
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "AutomationJobScheduler");
            t.setDaemon(true);
            return t;
        });

        // Tính delay đến 00:00 đêm nay (hoặc ngày mai nếu đã qua 00:00)
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime nextMidnight = now.toLocalDate().atTime(LocalTime.MIDNIGHT).plusDays(1);
        long delayMinutes = Duration.between(now, nextMidnight).toMinutes();

        LOG.info("[AutomationJobScheduler] Server started. Next run in " + delayMinutes + " minutes (at " + nextMidnight
                + ")");

        scheduler.scheduleAtFixedRate(
                new AutomationJobRunner(),
                delayMinutes,
                24 * 60, // mỗi 24h
                TimeUnit.MINUTES);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
            LOG.info("[AutomationJobScheduler] Scheduler shut down.");
        }
    }
}
