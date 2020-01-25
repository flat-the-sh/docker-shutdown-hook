package com.github.yylat.shutdownhook;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.time.LocalDateTime;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ShutdownListenerConfig {

  @Bean
  public ServletListenerRegistrationBean<ServletContextListener> servletListener(
      @Value("${fileName}") String fileName) throws IOException {
    var srb = new ServletListenerRegistrationBean<ServletContextListener>();
    srb.setListener(new ShutdownListener(fileName));
    return srb;
  }

  static class ShutdownListener implements ServletContextListener {

    private final Path pathToFile;

    ShutdownListener(String fileName) throws IOException {
      pathToFile = Paths.get(fileName);
      Files.createDirectories(pathToFile.getParent());
      if (Files.notExists(pathToFile)) {
        Files.createFile(pathToFile);
      }
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
      write("context initialized");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
      write("context destroyed");
    }

    private void write(String str) {
      try {
        Files.writeString(pathToFile, String.format("%s - %s\n", LocalDateTime.now(), str),
            StandardOpenOption.APPEND);
      } catch (IOException e) {
        e.printStackTrace();
      }
    }

  }

}
