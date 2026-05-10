import express from "express";
import type { Request, Response } from "express";

const expressApp = express();

function getCurrentDateTimeZone(): string {
  const date = new Date();
  const options: Intl.DateTimeFormatOptions = {
    timeZoneName: "short",
  };
  const formatter = new Intl.DateTimeFormat("en-US", options);
  const parts = formatter.formatToParts(date);
  const timeZonePart = parts.find((part) => part.type === "timeZoneName");
  return timeZonePart ? timeZonePart.value : "Unknown Time Zone";
}

expressApp.get("/", (req: Request, res: Response) => {
  res.send(getCurrentDateTimeZone());
});

const PORT = process.env.PORT || 3000;

expressApp.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
